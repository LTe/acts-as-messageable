# typed: true
module Parlour
  class RbiGenerator < Generator
    # Represents a constant definition.
    class Constant < RbiObject
      sig do
        params(
          generator: Generator,
          name: String,
          value: Types::TypeLike,
          eigen_constant: T::Boolean,
          heredocs: T.nilable(String),
          block: T.nilable(T.proc.params(x: Constant).void)
        ).void
      end
      # Creates a new constant definition.
      #
      # @param name [String] The name of the constant.
      # @param value [String] The value of the constant, as a Ruby code string.
      # @param eigen_constant [Boolean] Whether this constant is defined on the
      #   eigenclass of the current namespace.
      # @param heredocs [String,nil] Definitions of the heredocs used in the value, if any
      def initialize(generator, name: '', value: '', eigen_constant: false, heredocs: nil, &block)
        super(generator, name)
        @value = value
        @heredocs = heredocs
        @eigen_constant = eigen_constant
        yield_self(&block) if block
      end

      # @return [String] The value or type of the constant.
      sig { returns(Types::TypeLike) }
      attr_reader :value

      # @return [Boolean] Whether this constant is defined on the eigenclass
      #   of the current namespace.
      attr_reader :eigen_constant

      # @return [String,nil] Definitions of the heredocs used in the value, if any
      attr_reader :heredocs

      sig { params(other: Object).returns(T::Boolean) }
      # Returns true if this instance is equal to another extend.
      #
      # @param other [Object] The other instance. If this is not a {Extend} (or a
      #   subclass of it), this will always return false.
      # @return [Boolean]
      def ==(other)
        Constant === other && name == other.name && value == other.value \
          && eigen_constant == other.eigen_constant && heredocs == other.heredocs
      end

      sig do
        override.params(
          indent_level: Integer,
          options: Options
        ).returns(T::Array[String])
      end
      # Generates the RBI lines for this constant.
      #
      # @param indent_level [Integer] The indentation level to generate the lines at.
      # @param options [Options] The formatting options to use.
      # @return [Array<String>] The RBI lines, formatted as specified.
      def generate_rbi(indent_level, options)
        if String === @value
          [
            options.indented(indent_level, "#{name} = #{@value}"),
          ] + [heredocs].compact
        else
          [
            options.indented(indent_level, "#{name} = T.let(nil, #{@value.generate_rbi})"),
          ] + [heredocs].compact
        end
      end

      sig do
        override.params(
          others: T::Array[RbiGenerator::RbiObject]
        ).returns(T::Boolean)
      end
      # Given an array of {Constant} instances, returns true if they may be
      # merged into this instance using {merge_into_self}. This is always false.
      #
      # @param others [Array<RbiGenerator::RbiObject>] An array of other
      #   {Constant} instances.
      # @return [Boolean] Whether this instance may be merged with them.
      def mergeable?(others)
        others.all? { |other| self == other }
      end

      sig do
        override.params(
          others: T::Array[RbiGenerator::RbiObject]
        ).void
      end
      # Given an array of {Constant} instances, merges them into this one.
      # This particular implementation will simply do nothing, as instances
      # are only mergeable if they are indentical.
      # You MUST ensure that {mergeable?} is true for those instances.
      #
      # @param others [Array<RbiGenerator::RbiObject>] An array of other
      #   {Extend} instances.
      # @return [void]
      def merge_into_self(others)
        # We don't need to change anything! We only merge identical constants
      end

      sig { override.returns(T::Array[T.any(Symbol, T::Hash[Symbol, String])]) }
      def describe_attrs
        [:value, :eigen_constant, :heredocs]
      end

      sig { override.void }
      def generalize_from_rbi!
        if @value.is_a?(String)
          # There's a good chance this is an untyped constant, so rescue
          # ParseError and use untyped
          @value = TypeParser.parse_single_type(@value) rescue Types::Untyped.new
        end
      end
    end
  end
end
