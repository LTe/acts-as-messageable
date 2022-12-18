# typed: strict
# frozen_string_literal: true

module ActsAsMessageable
  class Rails3
    extend T::Sig

    # @return [ActsAsMessageable::Rails3] api wrapper object
    # @param [ActiveRecord::Base] subject
    sig { params(subject: T.any(T.class_of(ActiveRecord::Base), ActiveRecord::Base, T::Array[ActiveRecord::Base])).void }
    def initialize(subject)
      @subject = subject
    end

    # @return [Object]
    # @param [String, Symbol] order_by
    # @see ActiveRecord::Base#default_scope
    sig { params(order_by: T.any(String, Symbol)).void }
    def default_scope(order_by)
      # T.unsafe is needed here because the default_scope method is defined in
      # different ways in different versions of Rails. In Rails 3, it is a
      # class method, but in Rails 4, it is an instance method. We can't
      # statically determine which version of Rails is being used, so we have 
      # to use T.unsafe here.
      @subject.send(:default_scope, T.unsafe(@subject).order(order_by))
    end

    # @return [Object]
    # @param [Symbol] name
    # @param [Array] args
    sig { params(name: Symbol, args: T.untyped).returns(T.untyped) }
    def method_missing(name, *args)
      T.unsafe(@subject).send(name, *args) || super
    end

    # @return [Boolean]
    # @param [Object] method_name
    # @param [FalseClass] include_private
    sig {params(method_name: Symbol, include_private: T::Boolean).returns(T::Boolean)}
    def respond_to_missing?(method_name, include_private = false)
      method_name.to_s == 'default_scope' || super
    end
  end
end
