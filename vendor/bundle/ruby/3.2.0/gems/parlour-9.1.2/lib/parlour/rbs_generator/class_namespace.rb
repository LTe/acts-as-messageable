# typed: true
module Parlour
  class RbsGenerator < Generator
    # Represents a class definition.
    class ClassNamespace < Namespace
      extend T::Sig

      Child = type_member {{ fixed: RbsObject }}

      sig do
        params(
          generator: Generator,
          name: String,
          superclass: T.nilable(Types::TypeLike),
          block: T.nilable(T.proc.params(x: ClassNamespace).void)
        ).void
      end
      # Creates a new class definition.
      # @note You should use {Namespace#create_class} rather than this directly.
      #
      # @param generator [RbsGenerator] The current RbsGenerator.
      # @param name [String] The name of this class.
      # @param superclass [String, nil] The superclass of this class, or nil if it doesn't
      #   have one.
      # @param block A block which the new instance yields itself to.
      # @return [void]
      def initialize(generator, name, superclass, &block)
        super(generator, name, &T.cast(block, T.nilable(T.proc.params(x: Namespace).void)))
        @superclass = superclass
      end

      sig do
        override.params(
          indent_level: Integer,
          options: Options
        ).returns(T::Array[String])
      end
      def generate_rbs(indent_level, options)
        class_definition = @superclass.nil? \
          ? "class #{name}"
          : "class #{name} < #{String === @superclass ? @superclass : @superclass.generate_rbs}"
      
        lines = generate_comments(indent_level, options)
        lines << options.indented(indent_level, class_definition)
        lines += generate_body(indent_level + 1, options)
        lines << options.indented(indent_level, "end")
      end

      sig { returns(T.nilable(Types::TypeLike)) }
      # The superclass of this class, or nil if it doesn't have one.
      # @return [Types::TypeLike, nil]
      attr_reader :superclass

      sig do
        override.params(
          others: T::Array[RbsGenerator::RbsObject]
        ).returns(T::Boolean)
      end
      # Given an array of {Namespace} instances, returns true if they may
      # be merged into this instance using {merge_into_self}. For instances to
      # be mergeable, they must either all be abstract or all not be abstract,
      # and they must define the same superclass (or none at all).
      #
      # @param others [Array<RbsGenerator::RbsObject>] An array of other {Namespace} instances.
      # @return [Boolean] Whether this instance may be merged with them.
      def mergeable?(others)
        others = T.cast(others, T::Array[Namespace]) rescue (return false)
        all = others + [self]

        all_classes = T.cast(all.select { |x| ClassNamespace === x }, T::Array[ClassNamespace])

        all_classes.map(&:superclass).compact.uniq.length <= 1
      end

      sig do 
        override.params(
          others: T::Array[RbsGenerator::RbsObject]
        ).void
      end
      # Given an array of {ClassNamespace} instances, merges them into this one.
      # You MUST ensure that {mergeable?} is true for those instances.
      # 
      # @param others [Array<RbsGenerator::RbsObject>] An array of other {ClassNamespace} instances.
      # @return [void]
      def merge_into_self(others)
        super

        others.each do |other|
          next unless ClassNamespace === other
          other = T.cast(other, ClassNamespace)

          @superclass = other.superclass unless superclass
        end
      end

      sig { override.returns(T::Array[T.any(Symbol, T::Hash[Symbol, String])]) }
      def describe_attrs
        (superclass ? [:superclass] : []) + [:children]
      end
    end
  end
end
