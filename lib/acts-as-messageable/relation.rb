module ActsAsMessageable
  module Relation
    def process(*args, &block)
      to_a.send(:each, *args, &block)
    end
  end
end