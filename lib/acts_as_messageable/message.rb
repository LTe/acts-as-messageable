module ActsAsMessageable
  class Message < ::ActiveRecord::Base
    belongs_to :received_messageable, :polymorphic => true
    belongs_to :sent_messageable, :polymorphic => true

    attr_accessible :topic,
                    :body,
                    :received_messageable_type,
                    :received_messageable_id,
                    :sent_messageable_type,
                    :sent_messageable_id,
                    :opened

    validates_presence_of :topic ,:body

    def open?
      self.opened?
    end

    def open
      self.opened = true
    end

    def from
      "#{self.sent_messageable_type}".constantize.find(self.sent_messageable_id)
    end

    def to
      "#{self.received_messageable_type}".constantize.find(self.received_messageable_id)
    end

  end
end