# typed: strict
# frozen_string_literal: true

module ActsAsMessageable
  module Model
    extend T::Sig

    # @return [Object]
    # @param [Object] base
    sig { params(base: Module).returns(T.untyped) }
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      extend T::Helpers
      extend T::Sig

      requires_ancestor { T.class_of(ActiveRecord::Base) }

      # Method make ActiveRecord::Base object messageable
      # @option options [Symbol] :table_name table name for messages
      # @option options [String] :class_name message class name
      # @option options [Array, Symbol] :required required fields in message
      # @option options [Symbol] :dependent dependent option from ActiveRecord has_many method
      # @option options [Symbol] :search_scope name of a scope for a full text search
      # @param [Hash] options
      # @return [Object]
      sig do
        params(options: T::Hash[Symbol,
                                T.any(String, Symbol, T::Array[Symbol],
                                      T::Array[String])]).returns(ActsAsMessageable::Model::ClassMethods)
      end
      def acts_as_messageable(options = {})
        default_options = {
          table_name: 'messages',
          class_name: 'ActsAsMessageable::Message',
          required: %i[topic body],
          dependent: :nullify,
          group_messages: false,
          search_scope: :search
        }
        options = default_options.merge(options)

        mattr_accessor(:messages_class_name, :group_messages)

        has_many :received_messages_relation,
                 as: :received_messageable,
                 class_name: options[:class_name],
                 dependent: options[:dependent]
        has_many :sent_messages_relation,
                 as: :sent_messageable,
                 class_name: options[:class_name],
                 dependent: options[:dependent]

        self.messages_class_name = options[:class_name].constantize
        messages_class_name.has_ancestry

        messages_class_name.table_name = options[:table_name]
        messages_class_name.initialize_scopes(options[:search_scope])

        messages_class_name.required = Array.wrap(options[:required])
        messages_class_name.required.each do |attr|
          messages_class_name.validates attr, presence: true
        end
        self.group_messages = options[:group_messages]

        include ActsAsMessageable::Model::InstanceMethods
      end

      # Method recognize real object class
      # @return [ActiveRecord::Base] class or relation object
      sig { returns(T.class_of(ActiveRecord::Base)) }
      def resolve_active_record_ancestor
        reflect_on_association(:received_messages_relation).active_record
      end
    end

    module InstanceMethods
      extend T::Helpers
      extend T::Sig

      requires_ancestor { Kernel }
      requires_ancestor { CustomSearchUser }

      # @return [ActiveRecord::Relation] all messages connected with user
      # @param [Boolean] trash Show deleted messages
      sig { params(trash: T::Boolean).returns(ActiveRecord::Relation) }
      def messages(trash = false)
        result = self.class.messages_class_name.connected_with(self, trash)
        result.relation_context = self

        result
      end

      # @return [ActiveRecord::Relation] returns all messages from inbox
      sig { returns(ActiveRecord::Relation) }
      def received_messages
        result = received_messages_relation.scope.where(recipient_delete: false)
        result.relation_context = self

        result
      end

      # @return [ActiveRecord::Relation] returns all messages from outbox
      sig { returns(ActiveRecord::Relation) }
      def sent_messages
        result = sent_messages_relation.scope.where(sender_delete: false)
        result.relation_context = self

        result
      end

      # @return [ActiveRecord::Relation] returns all messages from trash
      sig { returns(ActiveRecord::Relation) }
      def deleted_messages
        messages(true)
      end

      # Method sends message to another user
      # @param [ActiveRecord::Base] to
      # @param [Hash] args
      # @option args [String] topic Topic of the message
      # @option args [String] body Body of the message
      # @return [ActsAsMessageable::Message] the message object
      sig do
        params(to: ActiveRecord::Base,
               args: T.any(String, T::Hash[T.any(String, Symbol), String])).returns(ActsAsMessageable::Message)
      end
      def send_message(to, *args)
        message_attributes = {}

        case args.first
        when String
          self.class.messages_class_name.required.each_with_index do |attribute, index|
            message_attributes[attribute] = args[index]
          end
        when Hash
          message_attributes = args.first
        end

        message = self.class.messages_class_name.new message_attributes
        message.received_messageable = to
        message.sent_messageable = self
        message.save!

        message
      end

      # Method send message to another user
      # and raise exception in case of validation errors
      # @param [ActiveRecord::Base] to
      # @param [Hash] args
      # @option [String] topic Topic of the message
      # @option [String] body Body of the message
      #
      # @return [ActsAsMessageable::Message] the message object
      sig do
        params(to: ActiveRecord::Base,
               args: T.any(String, T::Hash[T.any(String, Symbol), String])).returns(ActsAsMessageable::Message)
      end
      def send_message!(to, *args)
        T.unsafe(self).send_message(to, *T.unsafe(args)).tap(&:save!)
      end

      # Reply to given message
      # @param [ActsAsMessageable::Message] message
      # @param [Hash] args
      # @option args [String] topic Topic of the message
      # @option args [String] body Body of the message
      #
      # @return [ActsAsMessageable::Message] a message that is a response to a given message
      sig do
        params(message: ActsAsMessageable::Message,
               args: T.any(String,
                           T::Hash[T.any(String, Symbol), String])).returns(T.nilable(ActsAsMessageable::Message))
      end
      def reply_to(message, *args)
        current_user = T.cast(self, ActiveRecord::Base)

        return unless message.participant?(current_user)

        reply_message = T.unsafe(self).send_message(message.real_receiver(current_user), *args)
        reply_message.parent = message
        reply_message.save

        reply_message
      end

      # Mark message as deleted
      # @param [ActsAsMessageable::Message] message to delete
      # @return [ActsAsMessageable::Message] deleted message
      sig { params(message: ActsAsMessageable::Message).returns(T::Boolean) }
      def delete_message(message)
        current_user = self

        case current_user
        when message.to
          attribute = message.recipient_delete ? :recipient_permanent_delete : :recipient_delete
        when message.from
          attribute = message.sender_delete ? :sender_permanent_delete : :sender_delete
        else
          raise "#{current_user} can't delete this message"
        end

        message.update!(attribute => true)
      end

      # Mark message as restored
      # @param [ActsAsMessageable::Message] message to restore
      # @return [ActsAsMessageable::Message] restored message
      sig { params(message: ActsAsMessageable::Message).returns(T::Boolean) }
      def restore_message(message)
        current_user = self

        case current_user
        when message.to
          attribute = :recipient_delete
        when message.from
          attribute = :sender_delete
        else
          raise "#{current_user} can't restore this message"
        end

        message.update!(attribute => false)
      end
    end
  end
end
