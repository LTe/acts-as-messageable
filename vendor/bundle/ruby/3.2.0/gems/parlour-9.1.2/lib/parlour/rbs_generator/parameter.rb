# typed: true
module Parlour
  class RbsGenerator < Generator
    # Represents a method parameter with a Sorbet type signature.
    class Parameter
      extend T::Sig

      sig do
        params(
          name: String,
          type: T.nilable(Types::TypeLike),
          required: T::Boolean,
        ).void
      end
      # Create a new method parameter.
      # Note that, in RBS, blocks are not parameters. Use a {Block} instead.
      #
      # @example Create a simple Integer parameter named +num+.
      #   Parlour::RbsGenerator::Parameter.new('num', type: 'Integer')
      # @example Create a nilable array parameter.
      #   Parlour::RbsGenerator::Parameter.new('array_of_strings_or_symbols', type:
      #     Parlour::Types::Nilable.new(
      #       Parlour::Types::Array.new(
      #         Parlour::Types::Union.new('String', 'Symbol')
      #       )
      #     )
      #   )
      # @example Create an optional parameter.
      #   Parlour::RbsGenerator::Parameter.new('name', type: 'String', default: 'Parlour')
      #
      # @param name [String] The name of this parameter. This may start with +*+ or +**+,
      #   ,or end with +:+, which will infer the {kind} of this
      #   parameter. (If it contains none of those, {kind} will be +:normal+.)
      # @param type [Types::TypeLike, nil] This type of this parameter.
      # @param required [Boolean] Whether this parameter is required.
      # @return [void]
      def initialize(name, type: nil, required: true)
        name = T.must(name)
        @name = name

        prefix = /^(\*\*|\*|\&)?/.match(name)&.captures&.first || ''
        @kind = PREFIXES.rassoc(prefix).first

        @kind = :keyword if kind == :normal && name.end_with?(':')

        @type = type || Parlour::Types::Untyped.new
        @required = required
      end

      sig { params(other: Object).returns(T::Boolean) }
      # Returns true if this instance is equal to another method.
      #
      # @param other [Object] The other instance. If this is not a {Parameter} (or a
      #   subclass of it), this will always return false.
      # @return [Boolean]
      def ==(other)
        Parameter === other &&
          name    == other.name &&
          kind    == other.kind &&
          type    == other.type &&
          required == other.required
      end

      sig { returns(String) }
      # The name of this parameter, including any prefixes or suffixes such as
      # +*+.
      # @return [String]
      attr_reader :name

      sig { returns(String) }
      # The name of this parameter, stripped of any prefixes or suffixes. For
      # example, +*rest+ would become +rest+, or +foo:+ would become +foo+.
      #
      # @return [String]
      def name_without_kind
        return T.must(name[0..-2]) if kind == :keyword

        prefix_match = /^(\*\*|\*|\&)?[a-zA-Z_]/.match(name)
        raise 'unknown prefix' unless prefix_match
        prefix = prefix_match.captures.first || ''
        T.must(name[prefix.length..-1])
      end

      sig { returns(Types::TypeLike) }
      # This parameter's type.
      # @return [String]
      attr_reader :type

      sig { returns(T::Boolean) }
      # Whether this parameter is required.
      # @return [Boolean]
      attr_reader :required

      sig { returns(Symbol) }
      # The kind of parameter that this is. This will be one of +:normal+, 
      # +:splat+, +:double_splat+, or +:keyword+.
      # @return [Symbol]
      attr_reader :kind

      # An array of reserved keywords in RBS which may be used as parameter
      # names in standard Ruby.
      # TODO: probably incomplete
      RBS_KEYWORDS = [
        'type', 'interface', 'out', 'in', 'instance', 'extension', 'top', 'bot',
        'self', 'nil', 'void'
      ]

      # A mapping of {kind} values to the characteristic prefixes each kind has.
      PREFIXES = {
        normal: '',
        splat: '*',
        double_splat: '**',
      }.freeze      

      sig { returns(String) }
      # A string of how this parameter should be defined in an RBS signature.
      #
      # @return [String]
      def to_rbs_param
        raise 'blocks are not parameters in RBS' if kind == :block

        t = String === @type ? @type : @type.generate_rbs
        t = "^#{t}" if Types::Proc === @type

        if RBS_KEYWORDS.include? name_without_kind
          unless $VERBOSE.nil?
            print Rainbow("Parlour warning: ").yellow.dark.bold
            print Rainbow("RBS generation: ").magenta.bright.bold
            puts "'#{name_without_kind}' is a keyword in RBS, renaming method parameter to '_#{name_without_kind}'"
          end
          
          n = "_#{name_without_kind}"
        else
          n = name_without_kind
        end

        # Extra check because "?*something" is invalid
        ((required || (kind != :normal && kind != :keyword)) ? '' : '?') + if kind == :keyword
          "#{n}: #{t}"
        else
          "#{PREFIXES[kind]}#{t} #{n}"
        end
      end
    end
  end
end
