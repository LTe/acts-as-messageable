module ActsAsMessageable
  module Model

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_messageable
      class_eval do
        has_many :received_messages, :as => :received_messageable, :class_name => "ActsAsMessageable::Message"
        has_many :sent_messages, :as => :sent_messageable, :class_name => "ActsAsMessageable::Message"
      end

      include ActsAsMessageable::Model::InstanceMethods
    end

    end

    module InstanceMethods
      def messages(options = {})
        result = options.blank? ?  (self.received + self.sent) : ActsAsMessageable::Message.scoped
        current_user = self

        options.each do |key, value|
          case key
            when :from then
              result = result.messages_from(value, current_user)
            when :to then
              result = result.messages_to(value, current_user)
            when :id then
              result = result.message_id(value)
          end
        end

        result.each do |message|
          yield message
          delete_message(message) if message.delete_message
        end if block_given?

        result
      end

      def received(options = {})
        if options[:deleted] || options[:all]
          self.received_messages
        else
          self.received_messages.where(:recipient_delete => false)
        end

      end

      def sent(options = {})
        if options[:deleted] || options[:all]
          self.sent_messages
        else
          self.sent_messages.where(:sender_delete => false)
        end
      end

      def send_message(to, topic, body)
        @message = ActsAsMessageable::Message.create!(:topic => topic, :body => body)

        self.sent_messages << @message
        to.received_messages << @message
      end

      def delete_message(message)
        current_user = self

        if message.received_messageable == current_user
          message.update_attributes!(:recipient_delete => true)
        elsif message.sent_messageable == current_user
          message.update_attributes!(:sender_delete => true)
        end
      end

    end

  end
end
