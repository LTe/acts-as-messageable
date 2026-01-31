# typed: strict
# frozen_string_literal: true

require 'active_support/concern'

module ActsAsMessageable
  module Scopes
    extend ActiveSupport::Concern

    module ClassMethods
      # @return [Object]
      # @param [String, Symbol] search_scope
      extend T::Helpers
      extend T::Sig

      requires_ancestor { T.class_of(ActiveRecord::Base) }

      include Kernel

      sig { params(search_scope: T.any(String, Symbol)).void }
      def initialize_scopes(search_scope)
        initialize_scope_tracking
        return if scope_already_initialized?(search_scope)

        mark_scope_as_initialized(search_scope)
        define_base_scopes unless respond_to?(:are_from)
        define_search_scope(search_scope)
      end

      private

      sig { void }
      def initialize_scope_tracking
        @initialized_search_scopes ||= T.let([], T::Array[T.any(String, Symbol)])
      end

      sig { params(search_scope: T.any(String, Symbol)).returns(T::Boolean) }
      def scope_already_initialized?(search_scope)
        respond_to?(:are_from) && @initialized_search_scopes.include?(search_scope)
      end

      sig { params(search_scope: T.any(String, Symbol)).void }
      def mark_scope_as_initialized(search_scope)
        @initialized_search_scopes << search_scope unless @initialized_search_scopes.include?(search_scope)
      end

      sig { void }
      def define_base_scopes
        scope :are_from, lambda { |*args|
          where(sent_messageable_id: args.first, sent_messageable_type: args.first.class.name)
        }
        scope :are_to, lambda { |*args|
          where(received_messageable_id: args.first, received_messageable_type: args.first.class.name)
        }
        define_connected_with_scope
        scope :readed, -> { where('opened_at is not null OR opened = ?', true) }
        scope :unreaded, -> { where('opened_at is null OR opened = ?', false) }
        scope :deleted, -> { where(recipient_delete: true, sender_delete: true) }
      end

      sig { void }
      def define_connected_with_scope
        scope :connected_with, lambda { |*args|
          where("(sent_messageable_type = :sent_type and
                        sent_messageable_id = :sent_id and
                        sender_delete = :s_delete and sender_permanent_delete = :s_perm_delete) or
                        (received_messageable_type = :received_type and
                        received_messageable_id = :received_id and
                        recipient_delete = :r_delete and recipient_permanent_delete = :r_perm_delete)",
                sent_type: args.first.class.resolve_active_record_ancestor.to_s,
                sent_id: args.first.id,
                received_type: args.first.class.resolve_active_record_ancestor.to_s,
                received_id: args.first.id,
                r_delete: args.last,
                s_delete: args.last,
                r_perm_delete: false,
                s_perm_delete: false)
        }
      end

      sig { params(search_scope: T.any(String, Symbol)).void }
      def define_search_scope(search_scope)
        scope search_scope, lambda { |*args|
          where('body like :search_txt or topic like :search_txt', search_txt: "%#{args.first}%")
        }
      end
    end
  end
end
