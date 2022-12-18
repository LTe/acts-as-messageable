# typed: true
# frozen_string_literal: true

module ActsAsMessageable
  class Rails4
    # @return [ActsAsMessageable::Rails4] api wrapper object
    # @param [ActiveRecord::Base] subject
    def initialize(subject)
      @subject = subject
    end

    # Empty method for Rails 4.x
    # @return [NilClass]
    # @param [Array] _args
    def attr_accessible(*_args); end

    # Default scope for Rails 4.x with block support
    # @return [Object]
    # @param [String, Symbol] order_by
    def default_scope(order_by)
      @subject.send(:default_scope) { @subject.order(order_by) }
    end

    # Rename of the method
    # @return [Object]
    def scoped
      @subject.scope
    end

    # @return [Object]
    # @param [Symbol] name
    # @param [Array] args
    def method_missing(name, *args)
      @subject.send(name, *args) || super
    end

    # @return [Boolean]
    # @param [String] method_name
    # @param [Boolean] include_private
    def respond_to_missing?(method_name, include_private = false)
      %w[default_scope scoped attr_accessible].include?(method_name) || super
    end
  end
end
