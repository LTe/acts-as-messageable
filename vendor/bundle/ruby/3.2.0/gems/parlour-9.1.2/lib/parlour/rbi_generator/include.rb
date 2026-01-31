# typed: true
module Parlour
  class RbiGenerator < Generator
    # Represents an +include+ call.
    class Include < RbiObject
      sig do
        params(
          generator: Generator,
          name: String,
          block: T.nilable(T.proc.params(x: Include).void)
        ).void
      end
      # Creates a new +include+ call.
      #
      # @param name [String] The name of the object to be included.
      def initialize(generator, name: '', &block)
        super(generator, name)
        yield_self(&block) if block
      end

      sig { params(other: Object).returns(T::Boolean) }
      # Returns true if this instance is equal to another include.
      #
      # @param other [Object] The other instance. If this is not a {Include} (or a
      #   subclass of it), this will always return false.
      # @return [Boolean]
      def ==(other)
        Include === other && name == other.name
      end

      sig do
        override.params(
          indent_level: Integer,
          options: Options
        ).returns(T::Array[String])
      end
      # Generates the RBI lines for this include.
      #
      # @param indent_level [Integer] The indentation level to generate the lines at.
      # @param options [Options] The formatting options to use.
      # @return [Array<String>] The RBI lines, formatted as specified.
      def generate_rbi(indent_level, options)
        [options.indented(indent_level, "include #{name}")]
      end

      sig do
        override.params(
          others: T::Array[RbiGenerator::RbiObject]
        ).returns(T::Boolean)
      end
      # Given an array of {Include} instances, returns true if they may be 
      # merged into this instance using {merge_into_self}. This is always false.
      #
      # @param others [Array<RbiGenerator::RbiObject>] An array of other
      #   {Include} instances.
      # @return [Boolean] Whether this instance may be merged with them.
      def mergeable?(others)
        others.all? { |other| self == other }
      end

      sig do 
        override.params(
          others: T::Array[RbiGenerator::RbiObject]
        ).void
      end
      # Given an array of {Include} instances, merges them into this one.
      # This particular implementation will simply do nothing, as instances
      # are only mergeable if they are indentical.
      # You MUST ensure that {mergeable?} is true for those instances.
      #
      # @param others [Array<RbiGenerator::RbiObject>] An array of other
      #   {Include} instances.
      # @return [void]
      def merge_into_self(others)
        # We don't need to change anything! We only merge identical includes
      end

      sig { override.void }
      def generalize_from_rbi!; end # Nothing to do

      sig { override.returns(T::Array[T.any(Symbol, T::Hash[Symbol, String])]) }
      def describe_attrs
        []
      end
    end
  end
end
