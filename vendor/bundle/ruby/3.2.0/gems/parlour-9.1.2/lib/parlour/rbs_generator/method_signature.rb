# typed: true
module Parlour
  class RbsGenerator < Generator
    # Represents one signature in a method definition.
    # (This is not an RbsObject because it doesn't generate a full line.)
    class MethodSignature
      extend T::Sig

      sig do
        params(
          parameters: T::Array[Parameter],
          return_type: T.nilable(Types::TypeLike),
          block: T.nilable(Block),
          type_parameters: T.nilable(T::Array[Symbol])
        ).void
      end
      # Creates a new method signature.
      #
      # @param parameters [Array<Parameter>] An array of {Parameter} instances representing this 
      #   method's parameters.
      # @param return_type [Types::TypeLike, nil] What this method returns. Passing nil denotes a void return.
      # @param block [Types::TypeLike, nil] The block this method accepts. Passing nil denotes none.
      # @param type_parameters [Array<Symbol>, nil] This method's type parameters.
      # @return [void]
      def initialize(parameters, return_type = nil, block: nil, type_parameters: nil)
        @parameters = parameters
        @return_type = return_type
        @block = block
        @type_parameters = type_parameters || []
      end

      sig { overridable.params(other: Object).returns(T::Boolean).checked(:never) }
      # Returns true if this instance is equal to another method signature.
      #
      # @param other [Object] The other instance. If this is not a {MethodSignature} (or a
      #   subclass of it), this will always return false.
      # @return [Boolean]
      def ==(other)
        MethodSignature === other &&
          parameters      == other.parameters &&
          return_type     == other.return_type &&
          block           == other.block &&
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

      sig { returns(T.nilable(Block)) }
      # The block this method accepts.
      # @return [Block, nil]
      attr_reader :block

      sig { returns(T::Array[Symbol]) }
      # This method's type parameters.
      # @return [Array<Symbol>]
      attr_reader :type_parameters

      sig { params(options: Options).returns(T::Array[String]) }
      # Generates the RBS string for this signature.
      #
      # @param options [Options] The formatting options to use.
      # @return [Array<String>] The RBS string, formatted as specified.
      def generate_rbs(options)
        block_type = @block&.generate_rbs(options)

        rbs_params = parameters.reject { |x| x.kind == :block }.map(&:to_rbs_param)
        rbs_return_type = String === @return_type ? @return_type : @return_type&.generate_rbs

        generated_params = parameters.length >= options.break_params \
          ? ["("] +
            (
              parameters.empty? ? [] : rbs_params.map.with_index do |x, i|
                options.indented(
                  1,
                  # Don't include the comma on the last parameter.
                  parameters.length == i + 1 ? "#{x}" : "#{x},"
                )
              end
            ) +
            [")"]

          : ["(#{rbs_params.join(', ')})"]

        generated_params[0] = "#{
          type_parameters.any? ? "[#{type_parameters.join(', ')}] " : '' 
        }" + T.must(generated_params[0])

        generated_params[-1] = T.must(generated_params[-1]) + "#{
          (block_type && block_type.first != 'untyped') ? " #{block_type.first}" : '' # TODO: doesn't support multi-line block types
        } -> #{rbs_return_type || 'void'}"

        generated_params
      end

      sig { returns(String) }
      def describe_in_method
        # RBS is terse enough that just describing using the RBS is probably
        # fine. (Unfortunately, this doesn't allow any differentiation between 
        # string types and Parlour::Types types.)
        # (#describe is supposed to be one line, but this will break if you
        # have than 10000 parameters. Honestly, if you do have more than 10000
        # parameters, you deserve this...)
        generate_rbs(Parlour::Options.new(
          break_params: 10000, tab_size: 2, sort_namespaces: false
        )).join("\n")
      end
    end
  end
end
