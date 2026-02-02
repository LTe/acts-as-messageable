# typed: false
# frozen_string_literal: true

require 'mongoid/tree'
require_relative '../core'

module ActsAsMessageable
  module Mongoid
    class Message
      extend T::Sig

      include ::Mongoid::Document
      include ::Mongoid::Timestamps
      include ::Mongoid::Tree
      include ActsAsMessageable::Core::MessageBehavior
      include ActsAsMessageable::Mongoid::Scopes

      field :topic, type: String
      field :body, type: String
      field :opened, type: Boolean, default: false
      field :opened_at, type: Time
      field :recipient_delete, type: Boolean, default: false
      field :sender_delete, type: Boolean, default: false
      field :recipient_permanent_delete, type: Boolean, default: false
      field :sender_permanent_delete, type: Boolean, default: false

      belongs_to :received_messageable, polymorphic: true, optional: true
      belongs_to :sent_messageable, polymorphic: true, optional: true

      default_scope -> { order(created_at: :desc) }

      sig { returns(T::Boolean) }
      # Override opened? to handle Mongoid's attribute access
      def opened?
        opened_at.present? || !!attributes['opened']
      end

      sig { returns(T.untyped) }
      # mongoid-tree provides: parent, parent=, root, ancestors, descendants, children
      # We need to provide subtree which includes self + descendants
      def subtree
        descendant_ids = descendants.pluck(:_id)
        self.class.where(:$or => [{ _id: _id }, { _id: { :$in => descendant_ids } }])
            .order(created_at: :desc)
      end

      sig { params(name: T.any(String, Symbol)).returns(T.untyped) }
      # Override read_attribute for MessageBehavior compatibility
      def read_attribute(name)
        attributes[name.to_s]
      end
    end
  end
end
