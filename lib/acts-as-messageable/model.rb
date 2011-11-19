module ActsAsMessageable
  module Model

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      mattr_accessor :messages_class_name

      # Method make ActiveRecord::Base object messageable
      # @param [Symbol] :table_name - table name for messages
      def acts_as_messageable(options = {})
        has_many  :received_messages_relation, 
                  :as => :received_messageable, 
                  :class_name => options[:class_name] || "ActsAsMessageable::Message",
                  :dependent => :nullify
        has_many  :sent_messages_relation, 
                  :as => :sent_messageable,
                  :class_name => options[:class_name] || "ActsAsMessageable::Message",
                  :dependent => :nullify

        self.messages_class_name = (options[:class_name] || "ActsAsMessageable::Message").constantize
        self.messages_class_name.set_table_name(options[:table_name] || "messages")

        if options[:required].is_a? Symbol
          self.messages_class_name.required = [options[:required]]
        elsif options[:required].is_a? Array
          self.messages_class_name.required = options[:required]
        else
          self.messages_class_name.required = [:topic, :body]
        end

        self.messages_class_name.validates_presence_of self.messages_class_name.required
        include ActsAsMessageable::Model::InstanceMethods
    end

    end

    module InstanceMethods
      # Get all messages connected with user
      # @return [ActiveRecord::Relation] all messages connected with user
      def messages(trash = false)
        result = self.class.messages_class_name.connected_with(self, trash)
        result.relation_context = self

        result
      end

      def received_messages
        result = received_messages_relation.scoped.where(:recipient_delete => false)
        result.relation_context = self

        result
      end

      def sent_messages
        result = sent_messages_relation.scoped.where(:sender_delete => false)
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
            self.class.messages_class_name.required.each_with_index do |attribute, index|
              message_attributes[attribute] = args[index]
            end
          when Hash
            message_attributes = args.first
        end

        message = self.class.messages_class_name.create! message_attributes

        self.sent_messages_relation << message
        to.received_messages_relation << message

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
          unless message.recipient_delete
            message.update_attributes!(:recipient_delete => true)
          else
            message.update_attributes!(:recipient_permanent_delete => true)
          end
        elsif message.sent_messageable == current_user
          unless message.sender_delete
            message.update_attributes!(:sender_delete => true)
          else
            message.update_attributes!(:sender_permanent_delete => true)
          end
        end
      end

    end

  end
end
