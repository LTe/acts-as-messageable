# typed: false
# frozen_string_literal: true

require 'active_support/concern'

module ActsAsMessageable
  module Mongoid
    module Scopes
      extend ActiveSupport::Concern
      extend T::Sig

      included do
        scope :are_from, lambda { |user|
          where(sent_messageable_id: user._id, sent_messageable_type: user.class.name)
        }

        scope :are_to, lambda { |user|
          where(received_messageable_id: user._id, received_messageable_type: user.class.name)
        }

        scope :search, lambda { |text|
          where(:$or => [
                  { body: /#{Regexp.escape(text)}/i },
                  { topic: /#{Regexp.escape(text)}/i }
                ])
        }

        scope :connected_with, lambda { |user, trash = false|
          user_type = user.class.resolve_mongoid_ancestor.to_s
          user_id = user._id

          where(:$or => [
                  {
                    sent_messageable_type: user_type,
                    sent_messageable_id: user_id,
                    sender_delete: trash,
                    sender_permanent_delete: false
                  },
                  {
                    received_messageable_type: user_type,
                    received_messageable_id: user_id,
                    recipient_delete: trash,
                    recipient_permanent_delete: false
                  }
                ])
        }

        scope :readed, -> { where(:$or => [{ :opened_at.ne => nil }, { opened: true }]) }
        scope :unreaded, -> { where(:$or => [{ opened_at: nil }, { opened: false }]) }
        scope :deleted, -> { where(recipient_delete: true, sender_delete: true) }
      end

      module ClassMethods
        extend T::Sig

        sig { params(search_scope: T.any(String, Symbol)).void }
        def initialize_scopes(search_scope)
          return if search_scope == :search

          scope search_scope, lambda { |text|
            where(:$or => [
                    { body: /#{Regexp.escape(text)}/i },
                    { topic: /#{Regexp.escape(text)}/i }
                  ])
          }
        end
      end
    end
  end
end
