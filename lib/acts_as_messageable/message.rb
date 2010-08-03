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

    def from
      "#{self.messageable_type}".constantize.find(self.from_id)
    end

    def to
      "#{self.messageable_type}".constantize.find(self.to_id)
    end

  end
end