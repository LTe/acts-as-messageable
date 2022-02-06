# typed: false
# frozen_string_literal: true

module ActsAsMessageable
  class Rails6
    # @return [ActsAsMessageable::Rails4] api wrapper object
    # @param [ActiveRecord::Base] subject
    def initialize(subject)
      @subject = subject
    end

    # Empty method for Rails 3.x
    # @return [NilClass]
    def attr_accessible(*); end

    # Default scope for Rails 6.x with block support
    # @return [Object]
    # @param [String, Symbol] order_by
    def default_scope(order_by)
      @subject.send(:default_scope) { order(order_by) }
    end

    # Rename of the method
    # @return [Object]
    def scoped
      @subject.scope
    end

    # Use new method #update! in Rails 6.x
    # @return [Object]
    # @param [Array] args
    def update_attributes!(*args)
      @subject.update!(*args)
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
      %w[attr_accessible default_scope scoped update_attributes!].include?(method_name) || super
    end
  end
end
