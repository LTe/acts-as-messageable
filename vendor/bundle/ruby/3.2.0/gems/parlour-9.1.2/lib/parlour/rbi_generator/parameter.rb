# typed: true
require 'rainbow'
module Parlour
  class RbiGenerator < Generator
    # Represents a method parameter with a Sorbet type signature.
    class Parameter
      extend T::Sig

      sig do
        params(
          name: String,
          type: T.nilable(Types::TypeLike),
          default: T.nilable(String)
        ).void
      end
      # Create a new method parameter.
      #
      # @example Create a simple Integer parameter named +num+.
      #   Parlour::RbiGenerator::Parameter.new('num', type: 'Integer')
      # @example Create a nilable array parameter.
      #   Parlour::RbiGenerator::Parameter.new('array_of_strings_or_symbols', type: 'T.nilable(T::Array(String, Symbol))')
      # @example Create a block parameter.
      #   Parlour::RbiGenerator::Parameter.new('&blk', type: 'T.proc.void')
      # @example Create a parameter with a default value.
      #   Parlour::RbiGenerator::Parameter.new('name', type: 'String', default: 'Parlour')
      #
      # @param name [String] The name of this parameter. This may start with +*+, +**+,
      #   or +&+, or end with +:+, which will infer the {kind} of this
      #   parameter. (If it contains none of those, {kind} will be +:normal+.)
      # @param type [String, nil] A Sorbet string of this parameter's type, such as
      #   +"String"+ or +"T.untyped"+.
      # @param default [String, nil] A string of Ruby code for this parameter's default value.
      #   For example, the default value of an empty string would be represented
      #   as +"\"\""+ (or +'""'+). The default value of the decimal +3.14+
      #   would be +"3.14"+.
      # @return [void]
      def initialize(name, type: nil, default: nil)
        name = T.must(name)
        @name = name

        prefix = /^(\*\*|\*|\&)?/.match(name)&.captures&.first || ''
        @kind = T.must(PREFIXES.rassoc(prefix)).first

        @kind = :keyword if kind == :normal && name.end_with?(':')

        @type = type || 'T.untyped'
        @default = default
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
          default == other.default
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
      # A Sorbet string of this parameter's type, such as +"String"+ or
      # +"T.untyped"+.
      # @return [String]
      attr_reader :type

      sig { returns(T.nilable(String)) }
      # A string of Ruby code for this parameter's default value. For example,
      # the default value of an empty string would be represented as +"\"\""+
      # (or +'""'+). The default value of the decimal +3.14+ would be +"3.14"+.
      # @return [String, nil]
      attr_reader :default

      sig { returns(Symbol) }
      # The kind of parameter that this is. This will be one of +:normal+, 
      # +:splat+, +:double_splat+, +:block+ or +:keyword+.
      # @return [Symbol]
      attr_reader :kind

      sig { returns(String) }
      # A string of how this parameter should be defined in a method definition.
      #
      # @return [String]
      def to_def_param
        if default.nil?
          "#{name}"
        elsif !default.nil? && kind == :keyword
          "#{name} #{default}"
        else
          "#{name} = #{default}"
        end
      end

      sig { returns(String) }
      # A string of how this parameter should be defined in a Sorbet +sig+.
      #
      # @return [String]
      def to_sig_param
        "#{name_without_kind}: #{String === @type ? @type : @type.generate_rbi}"
      end

      # A mapping of {kind} values to the characteristic prefixes each kind has.
      PREFIXES = T.let({
        normal: '',
        splat: '*',
        double_splat: '**',
        block: '&'
      }.freeze, T::Hash[Symbol, String])

      sig { void }
      def generalize_from_rbi!
        @type = TypeParser.parse_single_type(@type) if String === @type
      end

      sig { returns(String) }
      def describe_in_method
        t = type
        t = t.is_a?(String) ? t : t.describe

        if default
          "#{name}: #{t} = #{default}"
        else
          "#{name}: #{t}"
        end
      end
    end
  end
end
