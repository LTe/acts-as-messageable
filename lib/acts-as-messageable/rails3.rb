module ActsAsMessageable
  class Rails3
    def initialize(subject)
      @subject = subject
    end

    def method_missing(name, *args)
      @subject.send(name, *args)
    end
  end
end
