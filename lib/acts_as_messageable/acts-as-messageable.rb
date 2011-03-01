module ActsAsMessageable
  module Model

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_messageable(options = {})
      class_eval do
        has_many  :received_messages, 
                  :as => :received_messageable, 
                  :class_name => "ActsAsMessageable::Message", 
                  :dependent => :nullify
        has_many  :sent_messages, 
                  :as => :sent_messageable,
                  :class_name => "ActsAsMessageable::Message", 
                  :dependent => :nullify
      end
      
      table_name = %q{set_table_name "#{options[:table_name] || "messages"}"}
      ActsAsMessageable::Message.class_eval(table_name)

      include ActsAsMessageable::Model::InstanceMethods
    end

    end

    module InstanceMethods
      def messages(options = {}, &block)
        result = options.blank? ?  (self.received + self.sent) : ActsAsMessageable::Message.scoped
        filter(result, options, &block)
      end

      def received(options = {}, &block)
        if options[:all]
          result = self.received_messages
        elsif options[:deleted]
          result = self.received_messages.where(:recipient_delete => true)
        else
          result = self.received_messages.where(:recipient_delete => false)
        end

        filter(result, options, &block)
      end

      def sent(options = {}, &block)
        if options[:all]
          result = self.sent_messages
        elsif options[:deleted]
          result = self.sent_messages.where(:sender_delete => true)
        else
          result = self.sent_messages.where(:sender_delete => false)
        end

        filter(result, options, &block)
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

      private

      def filter(result, options = {}, &block)
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
          block.call(message)
          delete_message(message) if message.delete_message
        end if block_given?

        result
      end

    end

  end
end
