module ActsAsMessageable
  module Relation
    attr_accessor :relation_context

    def process(*args, &block)
      to_a.send(:each, *args, &block)
    end
  end
end