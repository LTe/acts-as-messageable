# typed: ignore
# frozen_string_literal: true

module ActsAsMessageable
  class Message < ::ActiveRecord::Base
    include ActsAsMessageable::Scopes

    has_ancestry

    belongs_to :received_messageable, polymorphic: true
    belongs_to :sent_messageable, polymorphic: true

    attr_accessor :removed, :restored

    cattr_accessor :required

    ActsAsMessageable.rails_api.new(self).attr_accessible(
      :topic, :body, :opened, :opened_at, :recipient_permanent_delete,
      :recipient_delete, :sender_permanent_delete, :sender_delete
    )
    ActsAsMessageable.rails_api.new(self).default_scope('created_at desc')

    # @return [Boolean] whether the message has been read
    def open?
      opened?
    end

    # @return [Boolean] whether the message has been read
    # @see open?
    def opened?
      opened_at.present? || super
    end

    # Method open message (will mark message as read)
    # @return [ActsAsMessageable::Message] current message
    def open
      ActsAsMessageable.rails_api.new(self).update_attributes!(opened_at: DateTime.now)
      ActsAsMessageable.rails_api.new(self).update_attributes!(opened: true)
    end

    alias mark_as_read open
    alias read open

    # Method close message (will mark message as unread)
    # @return [ActsAsMessageable::Message] current message
    def close
      ActsAsMessageable.rails_api.new(self).update_attributes!(opened_at: nil)
      ActsAsMessageable.rails_api.new(self).update_attributes!(opened: false)
    end

    alias mark_as_unread close
    alias unread close

    alias from sent_messageable
    alias to received_messageable

    # @param [ActiveRecord::Base] user
    # @return [ActiveRecord::Associations::BelongsToAssociation] real receiver of the mssage
    def real_receiver(user)
      user == from ? to : from
    end

    # @return [Boolean] whether user is participant of group message
    # @param [ActiveRecord::Base] user
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

    # Method will mark message as removed
    # @return [TrueClass]
    def restore
      self.restored = true
    end

    # Reply to given message
    # @param [Hash] args
    # @option args [String] topic Topic of the message
    # @option args [String] body Body of the message
    # @return [ActsAsMessageable::Message] a message that is a response to a given message
    # @see ActsAsMessageable::Model::InstanceMethods#reply_to
    def reply(*args)
      to.reply_to(self, *args)
    end

    # Method will return list of users in the conversation
    # @return [Array<ActiveRecord::Base>] users
    def people
      conversation.map(&:from).uniq!
    end
  end
end
