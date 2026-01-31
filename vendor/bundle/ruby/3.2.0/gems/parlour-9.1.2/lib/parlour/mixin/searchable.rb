# typed: true

module Parlour
  module Mixin
    # Extends a particular type system's Namespace class to provide searchable
    # children.
    module Searchable
      extend T::Sig
      extend T::Generic

      Child = type_member {{ upper: TypedObject }}

      abstract!

      sig { abstract.returns(T::Array[Child]) }
      def children; end

      sig { params(name: T.nilable(String), type: T.nilable(Class)).returns(Child) }
      # Finds the first child matching the given predicates.
      #
      # @param [String, nil] name The name of the child to filter on, or nil.
      # @param [Class, nil] type The type of the child to filter on, or nil. The
      #   type is compared using #is_a?.
      def find(name: nil, type: nil)
        T.unsafe(children).find { |c| searchable_child_matches(c, name, type) }
      end

      sig { params(name: T.nilable(String), type: T.nilable(Class)).returns(T::Array[Child]) }
      # Finds the first child matching the given predicates.
      #
      # @param [String, nil] name The name of the child to filter on, or nil.
      # @param [Class, nil] type The type of the child to filter on, or nil. The
      #   type is compared using #is_a?.
      def find_all(name: nil, type: nil)
        T.unsafe(children).select { |c| searchable_child_matches(c, name, type) }
      end

      private

      sig do
        params(
          child: Child,
          name: T.nilable(String),
          type: T.nilable(Class)
        )
        .returns(T::Boolean)
      end
      def searchable_child_matches(child, name, type)
        (name.nil? ? true : child.name == name) \
        && (type.nil? ? true : child.is_a?(type))
      end
    end
  end
end
