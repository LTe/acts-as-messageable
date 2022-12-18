# typed: strict
# frozen_string_literal: true

module ActsAsMessageable
  class Rails4
    extend T::Sig

    # @return [ActsAsMessageable::Rails4] api wrapper object
    # @param [ActiveRecord::Base] subject
    sig { params(subject: T.any(T.class_of(ActiveRecord::Base), ActiveRecord::Base, T::Array[ActiveRecord::Base])).void }
    def initialize(subject)
      @subject = subject
    end

    # Empty method for Rails 4.x
    # @return [NilClass]
    # @param [Array] _args
    sig { params(_args: T::Array[T.any(String, Symbol)]).void }
    def attr_accessible(*_args); end

    # Default scope for Rails 4.x with block support
    # @return [Object]
    # @param [String, Symbol] order_by
    sig { params(order_by: T.any(String, Symbol)).returns(Object) }
    def default_scope(order_by)
      @subject.send(:default_scope) { T.cast(@subject, T.class_of(ActiveRecord::Base)).order(order_by) }
    end

    # Rename of the method
    # @return [Object]
    sig { returns(Object) }
    def scoped
      T.unsafe(@subject).scope
    end

    # @return [Object]
    # @param [Symbol] name
    # @param [Array] args
    sig { params(name: Symbol, args: T.untyped).returns(T.untyped) }
    def method_missing(name, *args)
      T.unsafe(@subject).send(name, *args) || super
    end

    # @return [Boolean]
    # @param [String] method_name
    # @param [Boolean] include_private
    sig {params(method_name: Symbol, include_private: T::Boolean).returns(T::Boolean)}
    def respond_to_missing?(method_name, include_private = false)
      %w[default_scope scoped attr_accessible].include?(method_name) || super
    end
  end
end
