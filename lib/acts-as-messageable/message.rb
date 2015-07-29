require 'ancestry'

module ActsAsMessageable
  class Message < ::ActiveRecord::Base
    include ActsAsMessageable::Scopes

    belongs_to :received_messageable, :polymorphic => true
    belongs_to :sent_messageable,     :polymorphic => true

    attr_accessible :topic, :body
    attr_accessor   :removed, :restored
    cattr_accessor  :required

    ActsAsMessageable.rails_api.new(self).default_scope("created_at desc")

    def open?
      self.opened?
    end

    def open
      update_attributes!(:opened => true)
    end
    alias :mark_as_read :open
    alias :read         :open

    def close
      update_attributes!(:opened => false)
    end
    alias :mark_as_unread :close
    alias :unread         :close

    alias :from :sent_messageable
    alias :to   :received_messageable

    def real_receiver(user)
      user == from ? to : from
    end

    def participant?(user)
      user.class.group_messages || (to == user) || (from == user)
    end

    def conversation
      root.subtree
    end

    def delete
      self.removed = true
    end

    def restore
      self.restored = true
    end

    def reply(*args)
      to.reply_to(self, *args)
    end

    def people
      conversation.map{ |x| x.from }.uniq!
    end
  end
end
