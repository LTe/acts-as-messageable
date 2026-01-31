# typed: false
# frozen_string_literal: true

module ActsAsMessageable
  module Mongoid
    module Relation
      attr_accessor :relation_context

      # @yield [ActsAsMessageable::Mongoid::Message] message
      # @param [Object] context of relation (most of the time current_user object)
      # @return [Mongoid::Criteria]
      def process(context = relation_context)
        each do |message|
          yield(message) if block_given?
          context.delete_message(message) if message.removed
          context.restore_message(message) if message.restored
        end
      end

      # @return [Array<ActsAsMessageable::Mongoid::Message>]
      def conversations
        map { |message| message.root.subtree.order(id: :desc).first }.uniq
      end
    end
  end
end
