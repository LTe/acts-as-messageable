# frozen_string_literal: true

module ActsAsMessageable
  class Rails4
    def initialize(subject)
      @subject = subject
    end

    def attr_accessible(*); end

    def default_scope(order_by)
      @subject.send(:default_scope) { order(order_by) }
    end

    def scoped
      @subject.scope
    end

    def method_missing(name, *args)
      @subject.send(name, *args) || super
    end

    def respond_to_missing?(method_name, include_private = false)
      %w[default_scope scoped attr_accessible].include?(method_name) || super
    end
  end
end
