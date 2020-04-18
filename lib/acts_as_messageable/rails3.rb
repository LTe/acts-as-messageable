# frozen_string_literal: true

module ActsAsMessageable
  class Rails3
    def initialize(subject)
      @subject = subject
    end

    def default_scope(order_by)
      @subject.send(:default_scope, order(order_by))
    end

    def method_missing(name, *args)
      @subject.send(name, *args) || super
    end

    def respond_to_missing?(method_name, include_private = false)
      method_name.to_s == 'default_scope' || super
    end
  end
end
