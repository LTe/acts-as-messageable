# typed: true
module Parlour
  class RbsGenerator < Generator
    # Represents a block in a method signature.
    # (This is not an RbsObject because it doesn't generate a full line.)
    class Block
      extend T::Sig

      sig { params(type: Types::Proc, required: T::Boolean).void }
      # Creates a new block for a method signature.
      #
      # @param type [Types::Proc] The type of this block.
      # @param required [T::Boolean] Whether this block is required.
      def initialize(type, required)
        @type = type
        @required = required
      end
      
      sig { overridable.params(other: Object).returns(T::Boolean).checked(:never) }
      # Returns true if this instance is equal to another method signature.
      #
      # @param other [Object] The other instance. If this is not a {MethodSignature} (or a
      #   subclass of it), this will always return false.
      # @return [Boolean]
      def ==(other)
        Block === other && type == other.type && required == other.required
      end

      sig { returns(Types::Proc) }
      # The type of this block.
      # @return [Types::Proc]
      attr_reader :type

      sig { returns(T::Boolean) }
      # Whether this block is required.
      # @return [Boolean]
      attr_reader :required

      sig { params(options: Options).returns(T::Array[String]) }
      # Generates the RBS string for this signature.
      #
      # @param options [Options] The formatting options to use.
      # @return [Array<String>] The RBS string, formatted as specified.
      def generate_rbs(options)
        ["#{required ? '' : '?'}{ #{type.generate_rbs} }"]
      end
    end
  end
end
