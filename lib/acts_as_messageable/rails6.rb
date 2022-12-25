# typed: strict
# frozen_string_literal: true

module ActsAsMessageable
  class Rails6
    extend T::Sig

    # @return [ActsAsMessageable::Rails4] api wrapper object
    # @param [ActiveRecord::Base] subject
    sig { params(subject: T.untyped).void }
    def initialize(subject)
      @subject = subject
    end

    # Empty method from Rails 3.x
    # @return [NilClass]
    # @param [Array] _args
    sig { params(_args: T.any(String, Symbol)).void }
    def attr_accessible(*_args); end

    # Default scope for Rails 6.x with block support
    # @return [Object]
    # @param [String, Symbol] order_by
    sig { params(order_by: T.any(String, Symbol)).returns(Object) }
    def default_scope(order_by)
      @subject.send(:default_scope) do
        T.bind(self, ActiveRecord::Relation)
        order(order_by)
      end
    end

    # Rename of the method
    # @return [Object]
    sig { returns(Object) }
    def scoped
      @subject.scope
    end

    # Use new method #update! in Rails 6.x
    # @return [Object]
    # @param [Array] args
    sig { params(args: T::Hash[String, String]).returns(T::Boolean) }
    def update_attributes!(*args)
      @subject.update!(*args)
    end

    # @return [Object]
    # @param [Symbol] name
    # @param [Array] args
    sig { params(name: Symbol, args: T.untyped).returns(T.untyped) }
    def method_missing(name, *args)
      @subject.send(name, *args) || super
    end

    # @return [Boolean]
    # @param [String] method_name
    # @param [Boolean] include_private
    sig { params(method_name: Symbol, include_private: T::Boolean).returns(T::Boolean) }
    def respond_to_missing?(method_name, include_private = false)
      %w[attr_accessible default_scope scoped update_attributes!].include?(method_name) || super
    end
  end
end
