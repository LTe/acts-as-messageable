module ActsAsMessageable
  class Rails4
    def initialize(subject)
      @subject = subject
    end

    def default_scope(order_by)
      @subject.default_scope { order(order_by) }
    end

    def scoped
      @subject.scope
    end

    def method_missing(name, *args)
      @subject.send(name, *args)
    end
  end
end
