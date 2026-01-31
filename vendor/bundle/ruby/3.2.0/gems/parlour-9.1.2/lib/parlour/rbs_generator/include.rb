# typed: true
module Parlour
  class RbsGenerator < Generator
    # Represents an +include+ call.
    class Include < RbsObject
      sig do
        params(
          generator: Generator,
          type: Types::TypeLike,
          block: T.nilable(T.proc.params(x: Include).void)
        ).void
      end
      # Creates a new +include+ call.
      #
      # @param type [Types::TypeLike] The type to include.
      def initialize(generator, type:, &block)
        super(generator, '')
        @type = type
        yield_self(&block) if block
      end

      sig { params(other: Object).returns(T::Boolean) }
      # Returns true if this instance is equal to another include.
      #
      # @param other [Object] The other instance. If this is not a {Include} (or a
      #   subclass of it), this will always return false.
      # @return [Boolean]
      def ==(other)
        Include === other && type == other.type
      end

      sig { returns(Types::TypeLike) }
      # @return [Types::TypeLike] The type to include.
      attr_reader :type

      sig do
        override.params(
          indent_level: Integer,
          options: Options
        ).returns(T::Array[String])
      end
      # Generates the RBS lines for this include.
      #
      # @param indent_level [Integer] The indentation level to generate the lines at.
      # @param options [Options] The formatting options to use.
      # @return [Array<String>] The RBS lines, formatted as specified.
      def generate_rbs(indent_level, options)
        [options.indented(indent_level, "include #{String === @type ? @type : @type.generate_rbs}")]
      end

      sig do
        override.params(
          others: T::Array[RbsGenerator::RbsObject]
        ).returns(T::Boolean)
      end
      # Given an array of {Include} instances, returns true if they may be 
      # merged into this instance using {merge_into_self}. This is always false.
      #
      # @param others [Array<RbsGenerator::RbsObject>] An array of other
      #   {Include} instances.
      # @return [Boolean] Whether this instance may be merged with them.
      def mergeable?(others)
        others.all? { |other| self == other }
      end

      sig do 
        override.params(
          others: T::Array[RbsGenerator::RbsObject]
        ).void
      end
      # Given an array of {Include} instances, merges them into this one.
      # This particular implementation will simply do nothing, as instances
      # are only mergeable if they are indentical.
      # You MUST ensure that {mergeable?} is true for those instances.
      #
      # @param others [Array<RbsGenerator::RbsObject>] An array of other
      #   {Include} instances.
      # @return [void]
      def merge_into_self(others)
        # We don't need to change anything! We only merge identical includes
      end

      sig { override.returns(T::Array[T.any(Symbol, T::Hash[Symbol, String])]) }
      def describe_attrs
        [{type: type}] # avoid quotes
      end
    end
  end
end
