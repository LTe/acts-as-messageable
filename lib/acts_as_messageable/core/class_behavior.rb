# typed: strict
# frozen_string_literal: true

require 'active_support/concern'
require 'sorbet-runtime'

module ActsAsMessageable
  module Core
    # Shared class method behavior for acts_as_messageable that works across both ActiveRecord and Mongoid
    module ClassBehavior
      extend ActiveSupport::Concern
      extend T::Sig

      class_methods do
        extend T::Sig

        sig { params(options: T::Hash[Symbol, T.untyped]).returns(T.untyped) }
        # Common setup logic for acts_as_messageable
        # @param [Hash] options
        # @return [Hash] merged options with defaults applied
        def setup_messageable(options)
          default_options = messageable_default_options
          options = default_options.merge(options)

          cattr_accessor(:messages_class_name, :group_messages)

          define_messageable_associations(options)

          self.messages_class_name = options[:class_name].constantize
          messages_class_name.initialize_scopes(options[:search_scope])

          messages_class_name.required = Array.wrap(options[:required])
          messages_class_name.required.each do |attr|
            messages_class_name.validates attr, presence: true
          end
          self.group_messages = options[:group_messages]

          options
        end

        sig { returns(T::Hash[Symbol, T.untyped]) }
        # Default options for acts_as_messageable - to be overridden by adapters
        def messageable_default_options
          {
            required: %i[topic body],
            dependent: :nullify,
            group_messages: false,
            search_scope: :search
          }
        end

        sig { params(options: T::Hash[Symbol, T.untyped]).void }
        # Define has_many associations - to be overridden by adapters
        def define_messageable_associations(options)
          raise NotImplementedError, 'Subclasses must implement define_messageable_associations'
        end
      end
    end
  end
end
