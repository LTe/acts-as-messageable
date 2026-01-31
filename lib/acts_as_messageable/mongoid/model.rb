# typed: false
# frozen_string_literal: true

module ActsAsMessageable
  module Mongoid
    module Model
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        # Method make Mongoid::Document object messageable
        # @option options [String] :class_name message class name
        # @option options [Array, Symbol] :required required fields in message
        # @option options [Symbol] :dependent dependent option from Mongoid has_many method
        # @option options [Symbol] :search_scope name of a scope for a full text search
        # @param [Hash] options
        # @return [Object]
        def acts_as_messageable(options = {})
          default_options = {
            class_name: 'ActsAsMessageable::Mongoid::Message',
            required: %i[topic body],
            dependent: :nullify,
            group_messages: false,
            search_scope: :search
          }
          options = default_options.merge(options)

          cattr_accessor(:messages_class_name, :group_messages)

          has_many :received_messages_relation,
                   as: :received_messageable,
                   class_name: options[:class_name],
                   dependent: options[:dependent]
          has_many :sent_messages_relation,
                   as: :sent_messageable,
                   class_name: options[:class_name],
                   dependent: options[:dependent]

          self.messages_class_name = options[:class_name].constantize
          messages_class_name.initialize_scopes(options[:search_scope])

          messages_class_name.required = Array.wrap(options[:required])
          messages_class_name.required.each do |attr|
            messages_class_name.validates attr, presence: true
          end
          self.group_messages = options[:group_messages]

          include ActsAsMessageable::Mongoid::Model::InstanceMethods
        end

        # Method recognize real object class
        # @return [Class] class or relation object
        def resolve_mongoid_ancestor
          relations['received_messages_relation'].class_name.constantize
          self
        end
      end

      module InstanceMethods
        # @return [Mongoid::Criteria] all messages connected with user
        # @param [Boolean] trash Show deleted messages
        def messages(trash = false)
          result = self.class.messages_class_name.connected_with(self, trash)
          result.relation_context = self

          result
        end

        # @return [Mongoid::Criteria] returns all messages from inbox
        def received_messages
          result = received_messages_relation.where(recipient_delete: false)
          result.relation_context = self

          result
        end

        # @return [Mongoid::Criteria] returns all messages from outbox
        def sent_messages
          result = sent_messages_relation.where(sender_delete: false)
          result.relation_context = self

          result
        end

        # @return [Mongoid::Criteria] returns all messages from trash
        def deleted_messages
          messages(true)
        end

        # Method sends message to another user
        # @param [Object] to
        # @param [Hash] args
        # @option args [String] topic Topic of the message
        # @option args [String] body Body of the message
        # @return [ActsAsMessageable::Mongoid::Message] the message object
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

          message = self.class.messages_class_name.new(message_attributes)
          message.received_messageable = to
          message.sent_messageable = self
          message.save!

          message
        end

        # Method send message to another user
        # and raise exception in case of validation errors
        # @param [Object] to
        # @param [Hash] args
        # @option [String] topic Topic of the message
        # @option [String] body Body of the message
        #
        # @return [ActsAsMessageable::Mongoid::Message] the message object
        def send_message!(to, *args)
          send_message(to, *args).tap(&:save!)
        end

        # Reply to given message
        # @param [ActsAsMessageable::Mongoid::Message] message
        # @param [Hash] args
        # @option args [String] topic Topic of the message
        # @option args [String] body Body of the message
        #
        # @return [ActsAsMessageable::Mongoid::Message] a message that is a response to a given message
        def reply_to(message, *args)
          current_user = self

          return unless message.participant?(current_user)

          reply_message = send_message(message.real_receiver(current_user), *args)
          reply_message.parent = message
          reply_message.save

          reply_message
        end

        # Mark message as deleted
        # @param [ActsAsMessageable::Mongoid::Message] message to delete
        # @return [Boolean] whether the message was deleted
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
        # @param [ActsAsMessageable::Mongoid::Message] message to restore
        # @return [Boolean] whether the message was restored
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
end
