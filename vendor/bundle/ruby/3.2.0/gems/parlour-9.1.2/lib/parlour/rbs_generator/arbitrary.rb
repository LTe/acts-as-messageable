# typed: true
module Parlour
  class RbsGenerator < Generator
    # Represents miscellaneous Ruby code.
    class Arbitrary < RbsObject
      sig do
        params(
          generator: Generator,
          code: String,
          block: T.nilable(T.proc.params(x: Arbitrary).void)
        ).void
      end
      # Creates new arbitrary code.
      #
      # @param code [String] The arbitrary code string. Indentation is added to
      #   the beginning of each line.
      def initialize(generator, code: '', &block)
        super(generator, '')
        @code = code
        yield_self(&block) if block
      end

      sig { returns(String) }
      # Returns arbitrary code string.
      attr_accessor :code

      sig { params(other: Object).returns(T::Boolean) }
      # Returns true if this instance is equal to another arbitrary code line.
      #
      # @param other [Object] The other instance. If this is not a {Arbitrary} (or a
      #   subclass of it), this will always return false.
      # @return [Boolean]
      def ==(other)
        Arbitrary === other && code == other.code
      end

      sig do
        override.params(
          indent_level: Integer,
          options: Options
        ).returns(T::Array[String])
      end
      # Generates the RBS lines for this arbitrary code.
      #
      # @param indent_level [Integer] The indentation level to generate the lines at.
      # @param options [Options] The formatting options to use.
      # @return [Array<String>] The RBS lines, formatted as specified.
      def generate_rbs(indent_level, options)
        code.split("\n").map { |l| options.indented(indent_level, l) }
      end

      sig do
        override.params(
          others: T::Array[RbsGenerator::RbsObject]
        ).returns(T::Boolean)
      end
      # Given an array of {Arbitrary} instances, returns true if they may be 
      # merged into this instance using {merge_into_self}. This is always false.
      #
      # @param others [Array<RbsGenerator::RbsObject>] An array of other
      #   {Arbitrary} instances.
      # @return [Boolean] Whether this instance may be merged with them.
      def mergeable?(others)
        false
      end

      sig do 
        override.params(
          others: T::Array[RbsGenerator::RbsObject]
        ).void
      end
      # Given an array of {Arbitrary} instances, merges them into this one.
      # This particular implementation always throws an exception, because
      # {mergeable?} is always false.
      #
      # @param others [Array<RbsGenerator::RbsObject>] An array of other
      #   {Arbitrary} instances.
      # @return [void]
      def merge_into_self(others)
        raise 'arbitrary code is never mergeable'
      end

      sig { override.returns(T::Array[T.any(Symbol, T::Hash[Symbol, String])]) }
      def describe_attrs
        [:code]
      end
    end
  end
end
