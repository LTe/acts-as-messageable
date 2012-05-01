module ActsAsMessageable
  module Relation
    attr_accessor :relation_context

    def process(context = self.relation_context, &block)
      self.each do |message|
        block.call(message) if block_given?
        context.delete_message(message)   if message.removed
        context.restore_message(message)  if message.restored
      end
    end
  end
end
