module ActsAsMessageable
  module Model

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      # Method make ActiveRecord::Base object messageable
      # @param [Symbol] :table_name - table name for messages
      def acts_as_messageable(options = {})
        has_many  :received_messages, 
                  :as => :received_messageable, 
                  :class_name => "ActsAsMessageable::Message", 
                  :dependent => :nullify
        has_many  :sent_messages, 
                  :as => :sent_messageable,
                  :class_name => "ActsAsMessageable::Message", 
                  :dependent => :nullify


        ActsAsMessageable::Message.set_table_name(options[:table_name] || "messages")
        ActsAsMessageable::Message.validates_presence_of(options[:required] || [:topic ,:body])

        if options[:required].is_a? Symbol
          ActsAsMessageable::Message.required = [options[:required]]
        elsif options[:required].is_a? Array
          ActsAsMessageable::Message.required = options[:required]
        else
          ActsAsMessageable::Message.required = [:topic, :body]
        end

        ActsAsMessageable::Message.validates_presence_of ActsAsMessageable::Message.required

        include ActsAsMessageable::Model::InstanceMethods
    end

    end

    module InstanceMethods
      # Get all messages connected with user
      # @return [ActiveRecord::Relation] all messages connected with user
      def messages(trash = false)
        result = ActsAsMessageable::Message.connected_with(self, trash)
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
            ActsAsMessageable::Message.required.each_with_index do |attribute, index|
              message_attributes[attribute] = args[index]
            end
          when Hash
            message_attributes = args.first
        end

        message = ActsAsMessageable::Message.create! message_attributes

        self.sent_messages << message
        to.received_messages << message

        message
      end

      def reply_to(message, *args)
        reply_message = send_message(message.from, *args)
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
