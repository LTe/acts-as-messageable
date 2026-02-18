# typed: strict
# frozen_string_literal: true

require 'active_support/concern'
require 'sorbet-runtime'

module ActsAsMessageable
  module Core
    # Shared model behavior that works across both ActiveRecord and Mongoid
    module ModelBehavior
      extend ActiveSupport::Concern
      extend T::Sig
      extend T::Helpers

      sig { params(trash: T::Boolean).returns(T.untyped) }
      # @return [Object] all messages connected with user
      # @param [Boolean] trash Show deleted messages
      def messages(trash = false)
        result = T.unsafe(self).class.messages_class_name.connected_with(self, trash)
        result.relation_context = self
        result
      end

      sig { returns(T.untyped) }
      # @return [Object] returns all messages from trash
      def deleted_messages
        messages(true)
      end

      sig { params(to: T.untyped, args: T.untyped).returns(T.untyped) }
      # Method sends message to another user
      # @param [Object] to
      # @param [Hash] args
      # @option args [String] topic Topic of the message
      # @option args [String] body Body of the message
      # @return [Object] the message object
      def send_message(to, *args)
        message_attributes = {}

        case args.first
        when String
          T.unsafe(self).class.messages_class_name.required.each_with_index do |attribute, index|
            message_attributes[attribute] = args[index]
          end
        when Hash
          message_attributes = T.cast(args.first, T::Hash[T.untyped, T.untyped])
        end

        message = T.unsafe(self).class.messages_class_name.new(message_attributes)
        message.received_messageable = to
        message.sent_messageable = self
        message.save!

        message
      end

      sig { params(to: T.untyped, args: T.untyped).returns(T.untyped) }
      # Method send message to another user
      # and raise exception in case of validation errors
      # @param [Object] to
      # @param [Hash] args
      # @option [String] topic Topic of the message
      # @option [String] body Body of the message
      #
      # @return [Object] the message object
      def send_message!(to, *args)
        send_message(to, *args).tap(&:save!)
      end

      sig { params(message: T.untyped, args: T.untyped).returns(T.nilable(T.untyped)) }
      # Reply to given message
      # @param [Object] message
      # @param [Hash] args
      # @option args [String] topic Topic of the message
      # @option args [String] body Body of the message
      #
      # @return [Object] a message that is a response to a given message
      def reply_to(message, *args)
        current_user = self

        return unless message.participant?(current_user)

        reply_message = send_message(message.real_receiver(current_user), *args)
        reply_message.parent = message
        reply_message.save

        reply_message
      end

      sig { params(message: T.untyped).returns(T::Boolean) }
      # Mark message as deleted
      # @param [Object] message to delete
      # @return [Boolean] whether the message was deleted
      def delete_message(message)
        current_user = self

        attribute = case current_user
                    when message.to
                      message.recipient_delete ? :recipient_permanent_delete : :recipient_delete
                    when message.from
                      message.sender_delete ? :sender_permanent_delete : :sender_delete
                    else
                      raise "#{current_user} can't delete this message"
                    end

        message.update!(attribute => true)
      end

      sig { params(message: T.untyped).returns(T::Boolean) }
      # Mark message as restored
      # @param [Object] message to restore
      # @return [Boolean] whether the message was restored
      def restore_message(message)
        current_user = self

        attribute = case current_user
                    when message.to
                      :recipient_delete
                    when message.from
                      :sender_delete
                    else
                      raise "#{current_user} can't restore this message"
                    end

        message.update!(attribute => false)
      end
    end
  end
end
