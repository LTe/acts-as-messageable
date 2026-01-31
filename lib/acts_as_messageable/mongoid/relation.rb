# typed: false
# frozen_string_literal: true

module ActsAsMessageable
  module Mongoid
    module Relation
      extend T::Sig
      extend T::Helpers

      sig { returns(T.untyped) }
      attr_accessor :relation_context

      sig { params(context: T.untyped, blk: T.untyped).void }
      # @yield [ActsAsMessageable::Mongoid::Message] message
      # @param [Object] context of relation (most of the time current_user object)
      # @return [Mongoid::Criteria]
      def process(context = relation_context, &blk) # rubocop:disable Lint/UnusedMethodArgument
        each do |message|
          yield(message) if block_given?
          context.delete_message(message) if message.removed
          context.restore_message(message) if message.restored
        end
      end

      sig { returns(T::Array[T.untyped]) }
      # @return [Array<ActsAsMessageable::Mongoid::Message>]
      def conversations
        map { |message| message.root.subtree.order(id: :desc).first }.uniq
      end
    end
  end
end
