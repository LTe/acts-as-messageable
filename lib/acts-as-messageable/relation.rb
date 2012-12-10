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

    def conversations
      map { |r| r.root.subtree.order("id desc").first }.uniq
    end
  end
end
