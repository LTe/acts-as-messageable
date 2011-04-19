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
                    :opened,
                    :recipient_delete,
                    :sender_delete

    attr_accessor :delete_message

    scope :messages_from,     lambda { |*args| where("sent_messageable_id = :sender", :sender => args.first).
                                           where("received_messageable_id = :receiver", :receiver => args.last) }
    scope :messages_to,       lambda { |*args| where("received_messageable_id = :receiver", :receiver => args.first).
                                           where("sent_messageable_id = :sender", :sender => args.last)}
    scope :message_id,        lambda { |*args| where("id = :id", :id => args.first) }
  
    scope :connected_with,    lambda { |*args|  where("(sent_messageable_type = :sent_type and
                                                sent_messageable_id = :sent_id and
                                                sender_delete = :deleted) or 
                                                (received_messageable_type = :received_type and
                                                received_messageable_id = :received_id and
                                                recipient_delete = :deleted)",
                                                :sent_type      => args.first.class.name, 
                                                :sent_id        => args.first.id,
                                                :received_type  => args.first.class.name,
                                                :received_id    => args.first.id,
                                                :deleted        => false)
                                     } 

                                  

    validates_presence_of :topic ,:body

    def open?
      self.opened?
    end

    def open
      update_attributes!(:opened => true)
    end

    def mark_as_read
      open
    end

    def close
      update_attributes!(:opened => false)
    end

    def mark_as_unread
      close
    end

    def from
      sent_messageable
    end

    def to
      received_messageable
    end

    def delete
      self.delete_message = true
    end

  end
end
