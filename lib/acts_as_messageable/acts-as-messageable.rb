module ActsAsMessageable
  module User

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_messageable
      class_eval do
        has_many :received_messages, :as => :received_messageable, :class_name => "ActsAsMessageable::Message"
        has_many :sent_messages, :as => :sent_messageable, :class_name => "ActsAsMessageable::Message"
      end

      include InstanceMethods
    end
      
    end

    module InstanceMethods
      def msg(args = {})

        all = self.recv + self.sent

        if args[:from] != nil && args[:to] == nil
          all.reject do |m|
            m.sent_messageable_id != args[:from].id
          end
        elsif args[:from] == nil && args[:to] != nil
          all.reject do |m|
            m.received_messageable_id != args[:to].id
          end
        elsif args[:id] != nil
          all.reject do |m|
            m.id != args[:id]
          end
        else
          all
        end

      end

      def recv
        self.received_messages
      end

      def sent
        self.sent_messages
      end

      def send_msg(to, topic, body)
        @message = ActsAsMessageable::Message.create
        @message.topic, @message.body = topic, body

        self.sent_messages << @message
        to.received_messages << @message 
      end

    end

  end
end