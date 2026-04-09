# typed: strict
# frozen_string_literal: true

require 'active_support/concern'
require 'sorbet-runtime'

module ActsAsMessageable
  module Core
    # Shared message behavior that works across both ActiveRecord and Mongoid
    module MessageBehavior
      extend ActiveSupport::Concern
      extend T::Sig
      extend T::Helpers

      included do
        attr_accessor :removed, :restored

        cattr_accessor :required
      end

      sig { returns(T::Boolean) }
      # @return [Boolean] whether the message has been read
      def open?
        opened?
      end

      sig { returns(T::Boolean) }
      # @return [Boolean] whether the message has been read
      def opened?
        T.unsafe(self).opened_at.present? || !!read_attribute(:opened)
      end

      sig { returns(T::Boolean) }
      # Method open message (will mark message as read)
      # @return [Boolean] whether the message has been open
      def open
        T.unsafe(self).update!(opened_at: Time.current, opened: true)
      end

      sig { returns(T::Boolean) }
      def mark_as_read
        open
      end

      sig { returns(T::Boolean) }
      def read
        open
      end

      sig { returns(T::Boolean) }
      # Method close message (will mark message as unread)
      # @return [Boolean] whether the message has been closed
      def close
        T.unsafe(self).update!(opened_at: nil, opened: false)
      end

      sig { returns(T::Boolean) }
      def mark_as_unread
        close
      end

      sig { returns(T::Boolean) }
      def unread
        close
      end

      sig { returns(T.untyped) }
      def from
        T.unsafe(self).sent_messageable
      end

      sig { returns(T.untyped) }
      def to
        T.unsafe(self).received_messageable
      end

      sig { params(user: T.untyped).returns(T.untyped) }
      # @param [Object] user
      # @return [Object] real receiver of the message
      def real_receiver(user)
        user == from ? to : from
      end

      sig { params(user: T.untyped).returns(T::Boolean) }
      # @return [Boolean] whether user is participant of group message
      # @param [Object] user
      def participant?(user)
        user.class.group_messages || (to == user) || (from == user)
      end

      sig { returns(T.untyped) }
      # @return [Object] conversation tree
      def conversation
        T.unsafe(self).root.subtree
      end

      sig { returns(TrueClass) }
      # Method will mark message as removed
      # @return [TrueClass]
      def delete
        T.unsafe(self).removed = true
      end

      sig { returns(TrueClass) }
      # Method will mark message as restored
      # @return [TrueClass]
      def restore
        T.unsafe(self).restored = true
      end

      sig { params(args: T.untyped).returns(T.untyped) }
      # Reply to given message
      # @param [Hash] args
      # @option args [String] topic Topic of the message
      # @option args [String] body Body of the message
      # @return [Object] a message that is a response to a given message
      # @return [Boolean] when user is not participant of the message
      def reply(*args)
        to.reply_to(self, *args)
      end

      sig { returns(T::Array[T.untyped]) }
      # Method will return list of users in the conversation
      # @return [Array<Object>] users
      def people
        conversation.map(&:from).uniq
      end

      sig { params(name: T.any(String, Symbol)).returns(T.untyped) }
      # Read attribute value - to be overridden by ORM-specific implementations
      def read_attribute(name)
        T.unsafe(self).attributes[name.to_s]
      end
    end
  end
end
