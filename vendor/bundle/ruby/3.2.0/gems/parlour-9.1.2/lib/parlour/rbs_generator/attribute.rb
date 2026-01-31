# typed: true
module Parlour
  class RbsGenerator < Generator
    # Represents an attribute reader, writer or accessor.
    class Attribute < RbsGenerator::Method
      extend T::Sig

      sig do
        params(
          generator: Generator,
          name: String,
          kind: Symbol,
          type: Types::TypeLike,
          block: T.nilable(T.proc.params(x: Attribute).void)
        ).void
      end
      # Creates a new attribute.
      # @note You should use {Namespace#create_attribute} rather than this directly.
      #
      # @param generator [RbsGenerator] The current RbsGenerator.
      # @param name [String] The name of this attribute.
      # @param kind [Symbol] The kind of attribute this is; one of :writer, :reader or
      #   :accessor.
      # @param type [String, Types::Type] This attribute's type.
      # @param block A block which the new instance yields itself to.
      # @return [void]
      def initialize(generator, name, kind, type, &block)
        @type = type
        @kind = kind
        case kind
        when :accessor, :reader
          super(generator, name, [MethodSignature.new([], type)], &T.cast(block, T.nilable(T.proc.params(x: Method).void)))
        when :writer
          super(generator, name, [MethodSignature.new([
            Parameter.new(name, type: type)
          ], type)], &T.cast(block, T.nilable(T.proc.params(x: Method).void)))
        else
          raise 'unknown kind'
        end
      end

      sig { returns(Symbol) }
      # The kind of attribute this is; one of +:writer+, +:reader+, or +:accessor+.
      # @return [Symbol]
      attr_reader :kind

      sig { returns(Types::TypeLike) }
      # The type of this attribute.
      attr_reader :type

      sig do
        override.params(
          indent_level: Integer,
          options: Options
        ).returns(T::Array[String])
      end
      # Generates the RBS lines for this arbstrary code.
      #
      # @param indent_level [Integer] The indentation level to generate the lines at.
      # @param options [Options] The formatting options to use.
      # @return [Array<String>] The RBS lines, formatted as specified.
      def generate_rbs(indent_level, options)
        generate_comments(indent_level, options) + [options.indented(
          indent_level,
          "attr_#{kind} #{name}: #{String === @type ? @type : @type.generate_rbs}"
        )]
      end

      sig { override.params(other: Object).returns(T::Boolean) }
      # Returns true if this instance is equal to another attribute.
      #
      # @param other [Object] The other instance. If this is not a {Attribute}
      #   (or a subclass of it), this will always return false.
      # @return [Boolean]
      def ==(other)
        T.must(
          super(other) && Attribute === other && kind == other.kind
        )
      end

      sig { override.returns(T::Array[T.any(Symbol, T::Hash[Symbol, String])]) }
      def describe_attrs
        [
          :kind,
          :class_attribute
        ]
      end
    end
  end
end
