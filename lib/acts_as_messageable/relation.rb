# typed: true
# frozen_string_literal: true

module ActsAsMessageable
  module Relation
    extend T::Sig
    extend T::Helpers

    sig { returns(ActsAsMessageable::Model::InstanceMethods) }
    attr_accessor :relation_context

    requires_ancestor { ActiveRecord::Relation }

    # @yield [ActsAsMessageable::Message] message
    # @param [ActiveRecord::Base] context of relation (most of the time current_user object)
    # @return [ActiveRecord::Relation]
    sig { params(context: ActsAsMessageable::Model::InstanceMethods).returns(T.untyped) }
    def process(context = relation_context)
      relation = T.cast(self, ActiveRecord::Relation)

      relation.each do |message|
        yield(message) if block_given?
        context.delete_message(message) if message.removed
        context.restore_message(message) if message.restored
      end
    end

    # @return [Array<ActsAsMessageable::Message>]
    # @return [ActiveRecord::Relation]
    def conversations
      relation = T.cast(self, ActiveRecord::Relation)
      relation.map { |message| message.root.subtree.order('id desc').first }.uniq
    end
  end
end
