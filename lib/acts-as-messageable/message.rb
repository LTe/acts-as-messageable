require 'ancestry'

module ActsAsMessageable
  class Message < ::ActiveRecord::Base
    has_ancestry

    belongs_to :received_messageable, :polymorphic => true
    belongs_to :sent_messageable,     :polymorphic => true

    attr_accessible :topic,
                    :body,
                    :received_messageable_type,
                    :received_messageable_id,
                    :sent_messageable_type,
                    :sent_messageable_id,
                    :opened,
                    :recipient_delete,
                    :sender_delete

    attr_accessor :context, :removed

    # Sample documentation for scope
    scope :are_from,          lambda { |*args| where("sent_messageable_id = :sender", :sender => args.first) }
    scope :are_to,            lambda { |*args| where("received_messageable_id = :receiver", :receiver => args.first) }
    scope :with_id,                lambda { |*args| where("id = :id", :id => args.first) }

    scope :connected_with,    lambda { |*args|  where("(sent_messageable_type = :sent_type and
                                                sent_messageable_id = :sent_id and
                                                sender_delete = :s_delete) or
                                                (received_messageable_type = :received_type and
                                                received_messageable_id = :received_id and
                                                recipient_delete = :r_delete)",
                                                :sent_type      => args.first.class.name,
                                                :sent_id        => args.first.id,
                                                :received_type  => args.first.class.name,
                                                :received_id    => args.first.id,
                                                :r_delete       => args.last,
                                                :s_delete       => args.last)
                                     }
    scope :readed,            lambda { where("opened = :opened", :opened => true)  }
    scope :unread,            lambda { where("opened = :opened", :opened => false) }
    scope :deleted,           lambda { where("recipient_delete = :r_delete AND sender_delete = :s_delete",
                                              :r_delete => true, :s_delete => true)}

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

    def conversation
      root.subtree
    end

    def delete
      self.removed = true
    end

  end
end
