# typed: false
# frozen_string_literal: true

require_relative '../core'

module ActsAsMessageable
  module Mongoid
    module Model
      extend T::Sig

      sig { params(base: T.untyped).returns(T.untyped) }
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        extend T::Sig
        include ActsAsMessageable::Core::ClassBehavior::ClassMethods

        sig { returns(T::Hash[Symbol, T.untyped]) }
        # Default options for Mongoid adapter
        def messageable_default_options
          {
            class_name: 'ActsAsMessageable::Mongoid::Message',
            required: %i[topic body],
            dependent: :nullify,
            group_messages: false,
            search_scope: :search
          }
        end

        sig { params(options: T::Hash[Symbol, T.untyped]).void }
        # Define has_many associations for Mongoid
        def define_messageable_associations(options)
          has_many :received_messages_relation,
                   as: :received_messageable,
                   class_name: options[:class_name],
                   dependent: options[:dependent]
          has_many :sent_messages_relation,
                   as: :sent_messageable,
                   class_name: options[:class_name],
                   dependent: options[:dependent]
        end

        sig { params(options: T::Hash[Symbol, T.untyped]).returns(T.untyped) }
        # Method make Mongoid::Document object messageable
        # @option options [String] :class_name message class name
        # @option options [Array, Symbol] :required required fields in message
        # @option options [Symbol] :dependent dependent option from Mongoid has_many method
        # @option options [Symbol] :search_scope name of a scope for a full text search
        # @param [Hash] options
        # @return [Object]
        def acts_as_messageable(options = {})
          setup_messageable(options)
          include ActsAsMessageable::Mongoid::Model::InstanceMethods
        end

        sig { returns(T.untyped) }
        # Method recognize real object class
        # @return [Class] class or relation object
        def resolve_mongoid_ancestor
          self
        end
      end

      module InstanceMethods
        extend T::Sig
        include ActsAsMessageable::Core::ModelBehavior

        sig { returns(T.untyped) }
        # @return [Mongoid::Criteria] returns all messages from inbox
        def received_messages
          result = T.unsafe(self).received_messages_relation.where(recipient_delete: false)
          result.relation_context = self
          result
        end

        sig { returns(T.untyped) }
        # @return [Mongoid::Criteria] returns all messages from outbox
        def sent_messages
          result = T.unsafe(self).sent_messages_relation.where(sender_delete: false)
          result.relation_context = self
          result
        end
      end
    end
  end
end
