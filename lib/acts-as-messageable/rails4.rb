module ActsAsMessageable
  class Rails4
    def initialize(subject)
      @subject = subject
    end

    def scoped
      @subject.scope
    end

    def method_missing(name, *args)
      @subject.send(name, *args)
    end
  end
end
