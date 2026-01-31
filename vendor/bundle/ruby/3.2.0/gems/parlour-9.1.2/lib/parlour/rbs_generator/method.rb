# typed: true
module Parlour
  class RbsGenerator < Generator
    # Represents a method definition.
    class Method < RbsObject
      extend T::Sig

      sig do
        params(
          generator: Generator,
          name: String,
          signatures: T::Array[MethodSignature],
          class_method: T::Boolean,
          block: T.nilable(T.proc.params(x: Method).void)
        ).void
      end
      # Creates a new method definition.
      # @note You should use {Namespace#create_method} rather than this directly.
      #
      # @param generator [RbsGenerator] The current RbsGenerator.
      # @param name [String] The name of this method. You should not specify +self.+ in
      #   this - use the +class_method+ parameter instead.
      # @param signatures [Array<MethodSignature>] The signatures for each
      #   overload of this method.
      # @param class_method [Boolean] Whether this method is a class method; that is, it
      #   it is defined using +self.+.
      # @param block A block which the new instance yields itself to.
      # @return [void]
      def initialize(generator, name, signatures, class_method: false, &block)
        super(generator, name)
        @signatures = signatures
        @class_method = class_method
        yield_self(&block) if block
      end

      sig { overridable.params(other: Object).returns(T::Boolean).checked(:never) }
      # Returns true if this instance is equal to another method.
      #
      # @param other [Object] The other instance. If this is not a {Method} (or a
      #   subclass of it), this will always return false.
      # @return [Boolean]
      def ==(other)
        Method === other &&
          name            == other.name &&
          signatures      == other.signatures &&
          class_method    == other.class_method
      end

      sig { returns(T::Array[MethodSignature]) }
      # The signatures for each overload of this method.
      # @return [Array<MethodSignature>]
      attr_reader :signatures

      sig { returns(T::Boolean) }
      # Whether this method is a class method; that is, it it is defined using
      # +self.+.
      # @return [Boolean]
      attr_reader :class_method

      sig do
        override.params(
          indent_level: Integer,
          options: Options
        ).returns(T::Array[String])
      end
      # Generates the RBS lines for this method.
      #
      # @param indent_level [Integer] The indentation level to generate the lines at.
      # @param options [Options] The formatting options to use.
      # @return [Array<String>] The RBS lines, formatted as specified.
      def generate_rbs(indent_level, options)
        definition = "def #{class_method ? 'self.' : ''}#{name}: "
        lines = generate_comments(indent_level, options)

        # Handle each signature
        signatures.each.with_index do |sig, i|
          this_sig_lines = []

          # Start off the first line of the signature, either with the definition
          # for the first signature, or a pipe for the rest
          if i == 0
            this_sig_lines << options.indented(indent_level, definition)
          else
            this_sig_lines << options.indented(indent_level, "#{' ' * (definition.length - 2)}| ")
          end

          # Generate the signature's lines, we'll append them afterwards
          partial_sig_lines = sig.generate_rbs(options)

          # Merge the first signature line, and indent & concat the rest
          first_line, *rest_lines = *partial_sig_lines
          this_sig_lines[0] = T.unsafe(this_sig_lines[0]) + first_line
          rest_lines.each do |line|
            this_sig_lines << ' ' * definition.length + options.indented(indent_level, line)
          end

          # Add on all this signature's lines to the complete lines
          lines += this_sig_lines
        end

        lines
      end

      sig do
        override.params(
          others: T::Array[RbsGenerator::RbsObject]
        ).returns(T::Boolean)
      end
      # Given an array of {Method} instances, returns true if they may be merged
      # into this instance using {merge_into_self}. For instances to be
      # mergeable, their signatures and definitions must be identical.
      #
      # @param others [Array<RbsGenerator::RbsObject>] An array of other {Method} instances.
      # @return [Boolean] Whether this instance may be merged with them.
      def mergeable?(others)
        others.all? { |other| self == other }
      end

      sig do 
        override.params(
          others: T::Array[RbsGenerator::RbsObject]
        ).void
      end
      # Given an array of {Method} instances, merges them into this one.
      # This particular implementation in fact does nothing, because {Method}
      # instances are only mergeable if they are identical, so nothing needs
      # to be changed.
      # You MUST ensure that {mergeable?} is true for those instances.
      #
      # @param others [Array<RbsGenerator::RbsObject>] An array of other {Method} instances.
      # @return [void]
      def merge_into_self(others)
        # TODO: merge signatures of different definitions
      end

      sig { override.returns(T::Array[T.any(Symbol, T::Hash[Symbol, String])]) }
      def describe_attrs
          [
            {signatures: "(#{signatures.map(&:describe_in_method).join(", ")})"},
            :class_method,
          ]
      end
    end
  end
end
