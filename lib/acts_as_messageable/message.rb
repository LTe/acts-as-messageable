module ActsAsMessageable
  class Message < ::ActiveRecord::Base
    belongs_to :messageable, :polymorphic => true

    attr_accessible :topic,
                    :body,
                    :messageable_type,
                    :messageable_id,
                    :from,
                    :to
  end
end