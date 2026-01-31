# typed: true
module Parlour
  class RbiGenerator < Generator
    # Represents a method definition.
    class Method < RbiObject
      extend T::Sig

      sig do
        params(
          generator: Generator,
          name: String,
          parameters: T::Array[Parameter],
          return_type: T.nilable(Types::TypeLike),
          abstract: T::Boolean,
          implementation: T::Boolean,
          override: T::Boolean,
          overridable: T::Boolean,
          class_method: T::Boolean,
          final: T::Boolean,
          type_parameters: T.nilable(T::Array[Symbol]),
          block: T.nilable(T.proc.params(x: Method).void)
        ).void
      end
      # Creates a new method definition.
      # @note You should use {Namespace#create_method} rather than this directly.
      #
      # @param generator [RbiGenerator] The current RbiGenerator.
      # @param name [String] The name of this method. You should not specify +self.+ in
      #   this - use the +class_method+ parameter instead.
      # @param parameters [Array<Parameter>] An array of {Parameter} instances representing this 
      #   method's parameters.
      # @param return_type [Types::TypeLike, nil] What this method returns. Passing nil denotes a void return.
      # @param abstract [Boolean] Whether this method is abstract.
      # @param implementation [Boolean] DEPRECATED: Whether this method is an 
      #   implementation of a parent abstract method.
      # @param override [Boolean] Whether this method is overriding a parent overridable
      #   method, or implementing a parent abstract method.
      # @param overridable [Boolean] Whether this method is overridable by subclasses.
      # @param class_method [Boolean] Whether this method is a class method; that is, it
      #   it is defined using +self.+.
      # @param final [Boolean] Whether this method is final.
      # @param type_parameters [Array<Symbol>, nil] This method's type parameters.
      # @param block A block which the new instance yields itself to.
      # @return [void]
      def initialize(generator, name, parameters, return_type = nil, abstract: false, implementation: false, override: false, overridable: false, class_method: false, final: false, type_parameters: nil, &block)
        super(generator, name)
        @parameters = parameters
        @return_type = return_type
        @abstract = abstract
        @implementation = implementation
        @override = override
        @overridable = overridable
        @class_method = class_method
        @final = final
        @type_parameters = type_parameters || []
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
          parameters      == other.parameters &&
          return_type     == other.return_type &&
          abstract        == other.abstract &&
          implementation  == other.implementation &&
          override        == other.override &&
          overridable     == other.overridable &&
          class_method    == other.class_method &&
          final           == other.final &&
          type_parameters == other.type_parameters
      end

      sig { returns(T::Array[Parameter]) }
      # An array of {Parameter} instances representing this method's parameters.
      # @return [Array<Parameter>]
      attr_reader :parameters

      sig { returns(T.nilable(Types::TypeLike)) }
      # What this method returns. Passing nil denotes a void return.
      # @return [Types::TypeLike, nil]
      attr_reader :return_type

      sig { returns(T::Boolean) }
      # Whether this method is abstract.
      # @return [Boolean]
      attr_reader :abstract

      sig { returns(T::Boolean) }
      # Whether this method is an implementation of a parent abstract method.
      # @deprecated Removed from Sorbet, as {#override} is used for both
      #   abstract class implementations and superclass overrides. In Parlour,
      #   this will now generate +override+.
      # @return [Boolean]
      attr_reader :implementation

      sig { returns(T::Boolean) }
      # Whether this method is overriding a parent overridable method, or
      #   implementing a parent abstract method.
      # @return [Boolean]
      attr_reader :override

      sig { returns(T::Boolean) }
      # Whether this method is overridable by subclasses.
      # @return [Boolean]
      attr_reader :overridable

      sig { returns(T::Boolean) }
      # Whether this method is a class method; that is, it it is defined using
      # +self.+.
      # @return [Boolean]
      attr_reader :class_method

      sig { returns(T::Boolean) }
      # Whether this method is final.
      # @return [Boolean]
      attr_reader :final

      sig { returns(T::Array[Symbol]) }
      # This method's type parameters.
      # @return [Array<Symbol>]
      attr_reader :type_parameters

      sig do
        override.params(
          indent_level: Integer,
          options: Options
        ).returns(T::Array[String])
      end
      # Generates the RBI lines for this method.
      #
      # @param indent_level [Integer] The indentation level to generate the lines at.
      # @param options [Options] The formatting options to use.
      # @return [Array<String>] The RBI lines, formatted as specified.
      def generate_rbi(indent_level, options)
        return_call = @return_type ? "returns(#{String === @return_type ? @return_type : @return_type.generate_rbi})" : 'void'
        sig_args = final ? '(:final)' : ''

        sig_params = parameters.map(&:to_sig_param)
        sig_lines = parameters.length >= options.break_params \
          ? [
              options.indented(indent_level, "sig#{sig_args} do"),
              options.indented(indent_level + 1, "#{qualifiers}params("),
            ] +
            (
              parameters.empty? ? [] : sig_params.map.with_index do |x, i|
                options.indented(
                  indent_level + 2,
                  # Don't include the comma on the last parameter.
                  parameters.length == i + 1 ? "#{x}" : "#{x},"
                )
              end
            ) +
            [
              options.indented(indent_level + 1, ").#{return_call}"),
              options.indented(indent_level, 'end')
            ]

          : [options.indented(
              indent_level,
              "sig#{sig_args} { #{parameters.empty? ? qualifiers[0...-1] : qualifiers}#{
                parameters.empty? ? '' : "params(#{sig_params.join(', ')})"
              }#{
                qualifiers.empty? && parameters.empty? ? '' : '.'
              }#{return_call} }"
            )]        

        generate_comments(indent_level, options) + sig_lines +
          generate_definition(indent_level, options)
      end

      sig do
        override.params(
          others: T::Array[RbiGenerator::RbiObject]
        ).returns(T::Boolean)
      end
      # Given an array of {Method} instances, returns true if they may be merged
      # into this instance using {merge_into_self}. For instances to be
      # mergeable, their signatures and definitions must be identical.
      #
      # @param others [Array<RbiGenerator::RbiObject>] An array of other {Method} instances.
      # @return [Boolean] Whether this instance may be merged with them.
      def mergeable?(others)
        others.all? { |other| self == other }
      end

      sig do 
        override.params(
          others: T::Array[RbiGenerator::RbiObject]
        ).void
      end
      # Given an array of {Method} instances, merges them into this one.
      # This particular implementation in fact does nothing, because {Method}
      # instances are only mergeable if they are identical, so nothing needs
      # to be changed.
      # You MUST ensure that {mergeable?} is true for those instances.
      #
      # @param others [Array<RbiGenerator::RbiObject>] An array of other {Method} instances.
      # @return [void]
      def merge_into_self(others)
        # We don't need to change anything! We only merge identical methods
      end

      sig { override.void }
      def generalize_from_rbi!
        @return_type = TypeParser.parse_single_type(@return_type) if String === @return_type

        parameters.each(&:generalize_from_rbi!)
      end

      sig { override.returns(T::Array[T.any(Symbol, T::Hash[Symbol, String])]) }
      def describe_attrs
        (type_parameters.any? ? [{ type_parameters: type_parameters.join(", ")}] : []) \
          + [
            {parameters: "(#{parameters.map(&:describe_in_method).join(", ")})"},
            {return_type: return_type || '(void)'}, # avoid quotes
            :class_method,
            :abstract,
            :implementation,
            :override,
            :overridable,
            :final,
          ]
      end

      private

      sig do
        overridable.params(
          indent_level: Integer,
          options: Options
        ).returns(T::Array[String])
      end
      # Generates the RBI lines for this method.
      # 
      # @param indent_level [Integer] The indentation level to generate the lines at.
      # @param options [Options] The formatting options to use.
      # @return [Array<String>] The RBI lines, formatted as specified.
      def generate_definition(indent_level, options)
        def_params = parameters.map(&:to_def_param)
        name_prefix = class_method ? 'self.' : ''
        def_line = options.indented(
          indent_level,
          "def #{name_prefix}#{name}#{
            "(#{def_params.join(', ')})" unless parameters.empty?}; end"
        )
        [def_line]
      end

      sig { returns(String) }
      # Returns the qualifiers which go in front of the +params+ part of this
      # method's Sorbet +sig+. For example, if {abstract} is true, then this
      # will return +abstract.+.
      #
      # @return [String]
      def qualifiers
        result = ''
        result += 'abstract.' if abstract
        result += 'override.' if override || implementation
        result += 'overridable.' if overridable
        result += "type_parameters(#{
          type_parameters.map { |t| ":#{t}" }.join(', ')
        })." if type_parameters.any?
        result
      end
    end
  end
end
