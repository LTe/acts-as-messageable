# frozen_string_literal: true

module ActsAsMessageable
  class Rails6
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

    def update_attributes!(*args)
      @subject.update!(*args)
    end

    def method_missing(name, *args)
      @subject.send(name, *args) || super
    end

    def respond_to_missing?(method_name, include_private = false)
      %w[attr_accessible default_scope scoped update_attributes!].include?(method_name) || super
    end
  end
end
