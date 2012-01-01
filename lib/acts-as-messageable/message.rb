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
                    :sender_delete,
                    :recipient_permanent_delete,
                    :sender_permanent_delete,
                    :created_at,
                    :updated_at

    attr_accessor   :removed
    cattr_accessor  :required


    # Sample documentation for scope
    default_scope order("created_at desc")
    scope :are_from,          lambda { |*args| where(:sent_messageable_id => args.first, :sent_messageable_type => args.first.class.name) }
    scope :are_to,            lambda { |*args| where(:received_messageable_id => args.first, :received_messageable_type => args.first.class.name) }
    scope :with_id,           lambda { |*args| where(:id => args.first) }

    scope :connected_with,    lambda { |*args|  where("(sent_messageable_type = :sent_type and
                                                sent_messageable_id = :sent_id and
                                                sender_delete = :s_delete and sender_permanent_delete = :s_perm_delete) or
                                                (received_messageable_type = :received_type and
                                                received_messageable_id = :received_id and
                                                recipient_delete = :r_delete and recipient_permanent_delete = :r_perm_delete)",
                                                :sent_type      => args.first.class.resolve_active_record_ancestor.to_s,
                                                :sent_id        => args.first.id,
                                                :received_type  => args.first.class.resolve_active_record_ancestor.to_s,
                                                :received_id    => args.first.id,
                                                :r_delete       => args.last,
                                                :s_delete       => args.last,
                                                :r_perm_delete  => false,
                                                :s_perm_delete  => false)
                                     }
    scope :readed,            lambda { where(:opened => true)  }
    scope :unread,            lambda { where(:opened => false) }
    scope :deleted,           lambda { where(:recipient_delete => true, :sender_delete => true) }

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

    def participant?(user)
      (to == user) || (from == user)
    end

    def conversation
      root.subtree
    end

    def delete
      self.removed = true
    end
    
    def reply(*args)
      to.reply_to(self, *args)
    end
  end
end
