# typed: true
# frozen_string_literal: true

module ActsAsMessageable
  module Relation
    extend T::Sig
    extend T::Helpers

    requires_ancestor { ActiveRecord::Relation }

    sig { returns(ActsAsMessageable::Model::InstanceMethods) }
    attr_accessor :relation_context

    # @yield [ActsAsMessageable::Message] message
    # @param [ActiveRecord::Base] context of relation (most of the time current_user object)
    # @return [ActiveRecord::Relation]
    sig { params(context: ActsAsMessageable::Model::InstanceMethods, blk: T.untyped).void }
    def process(context = relation_context, &blk)
      relation = T.cast(self, ActiveRecord::Relation)

      relation.each do |message|
        yield(message) if block_given?
        context.delete_message(message) if message.removed
        context.restore_message(message) if message.restored
      end
    end

    # @return [Array<ActsAsMessageable::Message>]
    sig { returns(T::Array[ActsAsMessageable::Message]) }
    def conversations
      relation = T.cast(self, ActiveRecord::Relation)
      relation.map { |message| message.root.subtree.order('id desc').first }.uniq
    end
  end
end
