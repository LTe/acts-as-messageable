# typed: false
# frozen_string_literal: true

module ActsAsMessageable
  module Mongoid
    class Message
      include ::Mongoid::Document
      include ::Mongoid::Timestamps
      include ActsAsMessageable::Mongoid::Scopes

      field :topic, type: String
      field :body, type: String
      field :opened, type: Boolean, default: false
      field :opened_at, type: Time
      field :recipient_delete, type: Boolean, default: false
      field :sender_delete, type: Boolean, default: false
      field :recipient_permanent_delete, type: Boolean, default: false
      field :sender_permanent_delete, type: Boolean, default: false
      field :ancestry, type: String

      belongs_to :received_messageable, polymorphic: true, optional: true
      belongs_to :sent_messageable, polymorphic: true, optional: true

      attr_accessor :removed, :restored

      cattr_accessor :required

      default_scope -> { order(created_at: :desc) }

      # @return [Boolean] whether the message has been read
      def open?
        opened?
      end

      # @return [Boolean] whether the message has been read
      def opened?
        opened_at.present? || attributes['opened']
      end

      # Method open message (will mark message as read)
      # @return [Boolean] whether the message has been open
      def open
        update!(opened_at: Time.current, opened: true)
      end

      alias mark_as_read open
      alias read open

      # Method close message (will mark message as unread)
      # @return [Boolean] whether the message has been closed
      def close
        update!(opened_at: nil, opened: false)
      end

      alias mark_as_unread close
      alias unread close

      def from
        sent_messageable
      end

      def to
        received_messageable
      end

      # @param [Object] user
      # @return [Object] real receiver of the message
      def real_receiver(user)
        user == from ? to : from
      end

      # @return [Boolean] whether user is participant of group message
      # @param [Object] user
      def participant?(user)
        user.class.group_messages || (to == user) || (from == user)
      end

      # @return [Object] conversation tree
      def conversation
        root.subtree
      end

      # Method will mark message as removed
      # @return [TrueClass]
      def delete
        self.removed = true
      end

      # Method will mark message as restored
      # @return [TrueClass]
      def restore
        self.restored = true
      end

      # Reply to given message
      # @param [Hash] args
      # @option args [String] topic Topic of the message
      # @option args [String] body Body of the message
      # @return [ActsAsMessageable::Mongoid::Message] a message that is a response to a given message
      # @return [Boolean] when user is not participant of the message
      def reply(*args)
        to.reply_to(self, *args)
      end

      # Method will return list of users in the conversation
      # @return [Array<Object>] users
      def people
        conversation.map(&:from).uniq
      end

      # Ancestry-like methods for Mongoid

      def parent
        return nil if ancestry.blank?

        self.class.where(_id: ancestry.split('/').last).first
      end

      def parent=(message)
        self.ancestry = if message.nil?
                          nil
                        elsif message.ancestry.blank?
                          message._id.to_s
                        else
                          "#{message.ancestry}/#{message._id}"
                        end
      end

      def root
        return self if ancestry.blank?

        self.class.where(_id: ancestry.split('/').first).first
      end

      def subtree
        escaped_id = Regexp.escape(_id.to_s)
        self.class.where(:$or => [
                           { _id: _id },
                           { ancestry: _id.to_s },
                           { ancestry: /^#{escaped_id}\// },
                           { ancestry: /\/#{escaped_id}$/ },
                           { ancestry: /\/#{escaped_id}\// }
                         ]).order(created_at: :desc)
      end
    end
  end
end
