module ActsAsMessageable
  class Rails3
    def initialize(subject)
      @subject = subject
    end

    def attr_accessible(*args)
      @subject.attr_accessible(*args)
    end

    def default_scope(order_by)
      @subject.send(:default_scope, order(order_by))
    end

    def method_missing(name, *args)
      @subject.send(name, *args)
    end
  end
end
