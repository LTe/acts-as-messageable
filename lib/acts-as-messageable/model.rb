module ActsAsMessageable
  module Model

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      mattr_accessor :messages_class_name

      # Method make ActiveRecord::Base object messageable
      # @param [Symbol] :table_name - table name for messages
      # @param [String] :class_name - message class name
      # @param [Array, Symbol] :required - required fields in message
      # @param [Symbol] :dependent - dependent option from ActiveRecord has_many method
      def acts_as_messageable(options = {})
        has_many  :received_messages_relation, 
                  :as => :received_messageable, 
                  :class_name => options[:class_name] || "ActsAsMessageable::Message",
                  :dependent => options[:dependent] || :nullify
        has_many  :sent_messages_relation, 
                  :as => :sent_messageable,
                  :class_name => options[:class_name] || "ActsAsMessageable::Message",
                  :dependent => options[:dependent] || :nullify

        self.messages_class_name = (options[:class_name] || "ActsAsMessageable::Message").constantize

        if self.messages_class_name.respond_to?(:table_name=)
          self.messages_class_name.table_name = (options[:table_name] || "messages")
        else
          self.messages_class_name.set_table_name(options[:table_name] || "messages")
          ActiveSupport::Deprecation.warn("Calling set_table_name is deprecated. Please use `self.table_name = 'the_name'` instead.")
        end

        self.messages_class_name.required = Array.wrap(options[:required] || [:topic, :body])
        self.messages_class_name.validates_presence_of self.messages_class_name.required

        include ActsAsMessageable::Model::InstanceMethods
    end

    # Method recognize real object class
    # @return [ActiveRecord::Base] class or relation object
    def resolve_active_record_ancestor
      self.reflect_on_association(:received_messages_relation).active_record
    end

    end

    module InstanceMethods
      # @return [ActiveRecord::Relation] all messages connected with user
      def messages(trash = false)
        result = self.class.messages_class_name.connected_with(self, trash)
        result.relation_context = self

        result
      end

      # @return [ActiveRecord::Relation] returns all messages from inbox
      def received_messages
        result = received_messages_relation.scoped.where(:recipient_delete => false)
        result.relation_context = self

        result
      end

      # @return [ActiveRecord::Relation] returns all messages from outbox
      def sent_messages
        result = sent_messages_relation.scoped.where(:sender_delete => false)
        result.relation_context = self

        result
      end

      # @return [ActiveRecord::Relation] returns all messages from trash
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

        message = self.class.messages_class_name.create message_attributes

        self.sent_messages_relation << message
        to.received_messages_relation << message

        message
      end

      # Reply to given message
      # @param [ActsAsMessageable::Message] message
      # @param [String] topic
      # @param [String] body
      #
      # @return [ActsAsMessageable::Message] a message that is a response to a given message
      def reply_to(message, *args)
        current_user = self

        if message.participant?(current_user)
          reply_message = send_message(message.from, *args)
          reply_message.parent = message
          reply_message.save

          reply_message
        end
      end

      # Mark message as deleted
      def delete_message(message)
        current_user = self

        if message.to == current_user
          unless message.recipient_delete
            message.update_attributes!(:recipient_delete => true)
          else
            message.update_attributes!(:recipient_permanent_delete => true)
          end
        elsif message.from == current_user
          unless message.sender_delete
            message.update_attributes!(:sender_delete => true)
          else
            message.update_attributes!(:sender_permanent_delete => true)
          end
        end
      end

      # Mark message as restored
      def restore_message(message)
        current_user = self

        if message.to == current_user
          message.update_attributes!(:recipient_delete => false)
        elsif message.from == current_user
          message.update_attributes!(:sender_delete => false)
        end
      end
    end
  end
end
