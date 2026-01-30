# typed: strict
# frozen_string_literal: true

require 'ancestry'

module ActsAsMessageable
  class Message < ::ActiveRecord::Base
    extend T::Sig

    include ActsAsMessageable::Scopes
    include Ancestry::InstanceMethods

    has_ancestry

    belongs_to :received_messageable, polymorphic: true
    belongs_to :sent_messageable, polymorphic: true

    sig { returns(T.nilable(T::Boolean)) }
    attr_accessor :removed, :restored

    cattr_accessor :required

    sig { params(args: T.untyped, kwargs: T.untyped).void }
    def initialize(*args, **kwargs)
      @removed = T.let(false, T.nilable(T::Boolean))
      @restored = T.let(false, T.nilable(T::Boolean))

      super
    end

    default_scope { order('created_at desc') }

    # @return [Boolean] whether the message has been read
    sig { returns(T::Boolean) }
    def open?
      opened?
    end

    # @return [Boolean] whether the message has been read
    # @see open?
    sig { returns(T::Boolean) }
    def opened?
      opened_at.present? || super
    end

    # Method open message (will mark message as read)
    # @return [Boolean] whether the message has been open
    sig { returns(T::Boolean) }
    def open
      update!(opened_at: Time.current)
      update!(opened: true)
    end

    alias mark_as_read open
    alias read open

    # Method close message (will mark message as unread)
    # @return [Boolean] whether the message has been closed
    sig { returns(T::Boolean) }
    def close
      update!(opened_at: nil)
      update!(opened: false)
    end

    alias mark_as_unread close
    alias unread close

    sig { returns(ActiveRecord::Base) }
    def from
      sent_messageable
    end

    sig { returns(ActiveRecord::Base) }
    def to
      received_messageable
    end

    # @param [ActiveRecord::Base] user
    # @return [ActiveRecord::Base] real receiver of the mssage
    sig { params(user: ActiveRecord::Base).returns(ActiveRecord::Base) }
    def real_receiver(user)
      user == from ? to : from
    end

    # @return [Boolean] whether user is participant of group message
    # @param [ActiveRecord::Base] user
    sig { params(user: T.untyped).returns(T::Boolean) }
    def participant?(user)
      user.class.group_messages || (to == user) || (from == user)
    end

    # @return [Object] conversation tree
    sig { returns(ActiveRecord::Relation) }
    def conversation
      root.subtree
    end

    # Method will mark message as removed
    # @return [TrueClass]
    sig { returns(TrueClass) }
    def delete
      self.removed = true
    end

    # Method will mark message as removed
    # @return [TrueClass]
    sig { returns(TrueClass) }
    def restore
      self.restored = true
    end

    # Reply to given message
    # @param [Hash] args
    # @option args [String] topic Topic of the message
    # @option args [String] body Body of the message
    # @return [ActsAsMessageable::Message] a message that is a response to a given message
    # @return [Boolean] when user is not participant of the message
    # @see ActsAsMessageable::Model::InstanceMethods#reply_to
    sig do
      params(args: T.any(T::Hash[String, String],
                         String)).returns(T.any(ActsAsMessageable::Message, T::Boolean, ActiveRecord::Base))
    end
    def reply(*args)
      T.unsafe(to).reply_to(self, *args)
    end

    # Method will return list of users in the conversation
    # @return [Array<ActiveRecord::Base>] users
    sig { returns(T::Array[ActiveRecord::Base]) }
    def people
      conversation.map(&:from).uniq
    end
  end
end
