# frozen_string_literal: true

module ActsAsMessageable
  module Relation
    attr_accessor :relation_context

    # @yield [ActsAsMessageable::Message] message
    # @param [ActiveRecord::Base] context of relation (most of the time current_user object)
    # @return [ActiveRecord::Relation]
    def process(context = relation_context)
      each do |message|
        yield(message) if block_given?
        context.delete_message(message) if message.removed
        context.restore_message(message) if message.restored
      end
    end

    # @return [Array<ActsAsMessageable::Message>]
    # @return [ActiveRecord::Relation]
    def conversations
      map { |r| r.root.subtree.order('id desc').first }.uniq
    end
  end
end
