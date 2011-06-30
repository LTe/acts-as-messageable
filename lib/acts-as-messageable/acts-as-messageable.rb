module ActsAsMessageable
  module Model

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      mattr_accessor :class_name
      
      # Method make ActiveRecord::Base object messageable
      # @param [Symbol] :table_name - table name for messages
      def acts_as_messageable(options = {})
        has_many  :received_messages, 
                  :as => :received_messageable, 
                  :class_name => options[:class_name] || "ActsAsMessageable::Message", 
                  :dependent => :nullify
        has_many  :sent_messages, 
                  :as => :sent_messageable,
                  :class_name => options[:class_name] || "ActsAsMessageable::Message", 
                  :dependent => :nullify
                  
        self.class_name = options[:class_name].constantize

        self.class_name.set_table_name(options[:table_name] || "messages")
        self.class_name.validates_presence_of(options[:required] || [:topic ,:body])
        self.class_name.required = options[:required] || [:topic, :body]
        
        include ActsAsMessageable::Model::InstanceMethods
    end

    end

    module InstanceMethods
      # Get all messages connected with user
      # @return [ActiveRecord::Relation] all messages connected with user
      def messages(trash = false)
        result = self.class_name.connected_with(self, trash)
        result.relation_context = self

        result
      end

      def deleted_messages
        messages true
      end

      # Method sens message to another user
      # @param [ActiveRecord::Base] to
      # @param [String] topic
      # @param [String] body
      #
      # @return [ActsAsMessageable::Message] the message object
      def send_message(to, *args)
        case args.first
          when String
            message_attributes = {}
            self.class_name.required.each_with_index do |attribute, index|
              message_attributes[attribute] = args[index]
            end
          when Hash
            message_attributes = args.first
        end

        message = self.class_name.create! message_attributes

        self.sent_messages << message
        to.received_messages << message

        message
      end

      def reply_to(message, topic, body)
        reply_message = send_message(self, topic, body)
        reply_message.parent = message
        reply_message.save

        reply_message
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
