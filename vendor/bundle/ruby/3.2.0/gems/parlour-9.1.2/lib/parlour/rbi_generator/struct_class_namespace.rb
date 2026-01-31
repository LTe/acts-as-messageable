# typed: true
module Parlour
  class RbiGenerator
    # Represents an struct definition; that is, a class which subclasses
    # +T::Struct+ and declares `prop` members.
    class StructClassNamespace < ClassNamespace
      extend T::Sig

      Child = type_member {{ fixed: RbiObject }}

      sig do
        params(
          generator: Generator,
          name: String,
          final: T::Boolean,
          sealed: T::Boolean,
          props: T::Array[StructProp],
          abstract: T::Boolean,
          block: T.nilable(T.proc.params(x: StructClassNamespace).void)
        ).void
      end
      # Creates a new struct class definition.
      # @note You should use {Namespace#create_struct_class} rather than this directly.
      #
      # @param generator [RbiGenerator] The current RbiGenerator.
      # @param name [String] The name of this class.
      # @param final [Boolean] Whether this namespace is final.
      # @param sealed [Boolean] Whether this namespace is sealed.
      # @param props [Array<StructProp>] The props of the struct.
      # @param abstract [Boolean] A boolean indicating whether this class is abstract.
      # @param block A block which the new instance yields itself to.
      # @return [void]
      def initialize(generator, name, final, sealed, props, abstract, &block)
        super(generator, name, final, sealed, 'T::Struct', abstract, &T.cast(block, T.nilable(T.proc.params(x: Namespace).void)))
        @props = props
      end

      sig { returns(T::Array[StructProp]) }
      # The props of the struct.
      # @return [Array<StructProp>]
      attr_reader :props

      sig do
        override.params(
          indent_level: Integer,
          options: Options,
        ).returns(T::Array[String])
      end
      # Generates the RBI lines for the body of this struct. This consists of
      # {props}, {includes}, {extends} and {children}.
      #
      # @param indent_level [Integer] The indentation level to generate the lines at.
      # @param options [Options] The formatting options to use.
      # @return [Array<String>] The RBI lines for the body, formatted as specified.
      def generate_body(indent_level, options)
        result = []
        props.each do |prop|
          result << options.indented(indent_level, prop.to_prop_call)
        end
        result << ''

        result + super
      end

      sig do
        override.params(
          others: T::Array[RbiGenerator::RbiObject]
        ).returns(T::Boolean)
      end
      # Given an array of {StructClassNamespace} instances, returns true if they may
      # be merged into this instance using {merge_into_self}. For instances to
      # be mergeable, they must either all be abstract or all not be abstract,
      # and they must define the same superclass (or none at all).
      #
      # @param others [Array<RbiGenerator::RbiObject>] An array of other {StructClassNamespace} instances.
      # @return [Boolean] Whether this instance may be merged with them.
      def mergeable?(others)
        others = T.cast(others, T::Array[Namespace]) rescue (return false)
        all = others + [self]
        all_structs = T.cast(all.select { |x| StructClassNamespace === x }, T::Array[StructClassNamespace])

        T.must(super && all_structs.map { |s| s.props.map(&:to_prop_call).sort }.reject(&:empty?).uniq.length <= 1)
      end

      sig do
        override.params(
          others: T::Array[RbiGenerator::RbiObject]
        ).void
      end
      # Given an array of {StructClassNamespace} instances, merges them into this one.
      # You MUST ensure that {mergeable?} is true for those instances.
      #
      # @param others [Array<RbiGenerator::RbiObject>] An array of other {StructClassNamespace} instances.
      # @return [void]
      def merge_into_self(others)
        super

        others.each do |other|
          next unless StructClassNamespace === other
          other = T.cast(other, StructClassNamespace)

          @props = other.props if props.empty?
        end
      end

      sig { override.void }
      def generalize_from_rbi!
        super

        props.each(&:generalize_from_rbi!)
      end

      sig { override.returns(T::Array[T.any(Symbol, T::Hash[Symbol, String])]) }
      def describe_attrs
        super + [{props: "(#{props.map(&:name)})"}]
      end
    end
  end
end