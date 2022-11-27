# frozen_string_literal: true

module ActsAsMessageable
  class Rails3
    # @return [ActsAsMessageable::Rails3] api wrapper object
    # @param [ActiveRecord::Base] subject
    def initialize(subject)
      @subject = subject
    end

    # @return [Object]
    # @param [String, Symbol] order_by
    # @see ActiveRecord::Base#default_scope
    def default_scope(order_by)
      @subject.send(:default_scope, order(order_by))
    end

    # @return [Object]
    # @param [Symbol] name
    # @param [Array] args
    def method_missing(name, *args)
      @subject.send(name, *args) || super
    end

    # @return [Boolean]
    # @param [Object] method_name
    # @param [FalseClass] include_private
    def respond_to_missing?(method_name, include_private = false)
      method_name.to_s == 'default_scope' || super
    end
  end
end
