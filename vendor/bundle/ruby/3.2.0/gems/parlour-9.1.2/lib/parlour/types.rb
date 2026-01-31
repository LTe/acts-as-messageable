# typed: true

module Parlour
  # Contains structured types which can be used in type signatures.
  module Types
    TypeLike = T.type_alias { T.any(String, Type) }

    # The top-level, abstract class for a generalised type. All of the other
    # types inherit from this. Do not instantiate.
    class Type
      extend T::Sig
      extend T::Helpers

      abstract!

      sig { abstract.returns(String) }
      def generate_rbi; end

      sig { abstract.returns(String) }
      def generate_rbs; end

      sig { params(type_like: TypeLike).returns(Type) }
      def self.to_type(type_like)
        if type_like.is_a?(String)
          Raw.new(type_like)
        else
          type_like
        end
      end

      sig { params(type_like: TypeLike).returns(Type) }
      def to_type(type_like)
        Type.to_type(type_like)
      end

      def hash
        [self.class, *instance_variables.map { |x| instance_variable_get(x).hash }].hash
      end

      sig { abstract.returns(String) }
      def describe; end
    end

    # A basic type as a raw string.
    class Raw < Type
      sig { params(str: String).void }
      def initialize(str)
        @str = str
      end

      sig { returns(String) }
      attr_reader :str

      sig { params(other: Object).returns(T::Boolean) }
      def ==(other)
        Raw === other && str == other.str
      end

      sig { override.returns(String) }
      def generate_rbi
        str
      end

      sig { override.returns(String) }
      def generate_rbs
        str
      end

      sig { override.returns(String) }
      def describe
        str
      end
    end

    # A type which can be either the wrapped type, or nil.
    class Nilable < Type
      sig { params(type: TypeLike).void }
      def initialize(type)
        @type = to_type(type)
      end

      sig { params(other: Object).returns(T::Boolean) }
      def ==(other)
        Nilable === other && type == other.type
      end

      sig { returns(Type) }
      attr_reader :type

      sig { override.returns(String) }
      def generate_rbi
        "T.nilable(#{type.generate_rbi})"
      end

      sig { override.returns(String) }
      def generate_rbs
        "#{type.generate_rbs}?"
      end

      sig { override.returns(String) }
      def describe
        "Nilable<#{type.describe}>"
      end
    end

    # A type which is (at least) one of the wrapped types.
    class Union < Type
      sig { params(types: T::Array[TypeLike]).void }
      def initialize(types)
        @types = types.map(&method(:to_type))
      end

      sig { params(other: Object).returns(T::Boolean) }
      def ==(other)
        Union === other && types == other.types
      end

      sig { returns(T::Array[Type]) }
      attr_reader :types

      sig { override.returns(String) }
      def generate_rbi
        "T.any(#{types.map(&:generate_rbi).join(', ')})"
      end

      sig { override.returns(String) }
      def generate_rbs
        "(#{types.map(&:generate_rbs).join(' | ')})"
      end

      sig { override.returns(String) }
      def describe
        "Union<#{types.map(&:describe).join(', ')}>"
      end
    end

    # A type which matches all of the wrapped types.
    class Intersection < Type
      sig { params(types: T::Array[TypeLike]).void }
      def initialize(types)
        @types = types.map(&method(:to_type))
      end

      sig { params(other: Object).returns(T::Boolean) }
      def ==(other)
        Intersection === other && types == other.types
      end

      sig { returns(T::Array[Type]) }
      attr_reader :types

      sig { override.returns(String) }
      def generate_rbi
        "T.all(#{types.map(&:generate_rbi).join(', ')})"
      end

      sig { override.returns(String) }
      def generate_rbs
        "(#{types.map(&:generate_rbs).join(' & ')})"
      end

      sig { override.returns(String) }
      def describe
        "Intersection<#{types.map(&:describe).join(', ')}>"
      end
    end

    # A fixed-length array of items, each with a known type.
    class Tuple < Type
      sig { params(types: T::Array[TypeLike]).void }
      def initialize(types)
        @types = types.map(&method(:to_type))
      end

      sig { params(other: Object).returns(T::Boolean) }
      def ==(other)
        Tuple === other && types == other.types
      end

      sig { returns(T::Array[Type]) }
      attr_reader :types

      sig { override.returns(String) }
      def generate_rbi
        "[#{types.map(&:generate_rbi).join(', ')}]"
      end

      sig { override.returns(String) }
      def generate_rbs
        "[#{types.map(&:generate_rbs).join(', ')}]"
      end

      sig { override.returns(String) }
      def describe
        "[#{types.map(&:describe).join(', ')}]"
      end
    end

    # A user-defined generic class with an arbitrary number of type
    # parameters. This class assumes at least one type_param is
    # provided, otherwise output will have empty type param lists.
    class Generic < Type
      sig { params(type: TypeLike, type_params: T::Array[TypeLike]).void }
      def initialize(type, type_params)
        @type = to_type(type)
        @type_params = type_params.map { |p| to_type(p) }
      end

      sig { params(other: Object).returns(T::Boolean) }
      def ==(other)
        self.class === other &&
          type == other.type &&
          type_params == other.type_params
      end

      sig { returns(Type) }
      attr_reader :type

      sig { returns(T::Array[Type]) }
      attr_reader :type_params

      sig { override.returns(String) }
      def generate_rbi
        "#{type.generate_rbi}[#{type_params.map(&:generate_rbi).join(', ')}]"
      end

      sig { override.returns(String) }
      def generate_rbs
        "#{type.generate_rbs}[#{type_params.map(&:generate_rbs).join(', ')}]"
      end

      sig { override.returns(String) }
      def describe
        "#{type.describe}<#{type_params.map(&:describe).join(', ')}>"
      end
    end

    class SingleElementCollection < Type
      abstract!

      sig { params(element: TypeLike).void }
      def initialize(element)
        @element = to_type(element)
      end

      sig { returns(Type) }
      attr_reader :element

      sig { abstract.returns(String) }
      def collection_name; end

      sig { override.returns(String) }
      def generate_rbi
        "T::#{collection_name}[#{element.generate_rbi}]"
      end

      sig { override.returns(String) }
      def generate_rbs
        "::#{collection_name}[#{element.generate_rbs}]"
      end

      sig { override.returns(String) }
      def describe
        "#{collection_name}<#{element.describe}>"
      end
    end

    # An array with known element types.
    class Array < SingleElementCollection
      sig { override.returns(String) }
      def collection_name
        'Array'
      end

      sig { params(other: Object).returns(T::Boolean) }
      def ==(other)
        Array === other && element == other.element
      end
    end

    # A set with known element types.
    class Set < SingleElementCollection
      sig { override.returns(String) }
      def collection_name
        'Set'
      end

      sig { params(other: Object).returns(T::Boolean) }
      def ==(other)
        Set === other && element == other.element
      end
    end

    # A range with known element types.
    class Range < SingleElementCollection
      sig { override.returns(String) }
      def collection_name
        'Range'
      end

      sig { params(other: Object).returns(T::Boolean) }
      def ==(other)
        Range === other && element == other.element
      end
    end

    # An enumerable with known element types.
    class Enumerable < SingleElementCollection
      sig { override.returns(String) }
      def collection_name
        'Enumerable'
      end

      sig { params(other: Object).returns(T::Boolean) }
      def ==(other)
        Enumerable === other && element == other.element
      end
    end

    # An enumerator with known element types.
    class Enumerator < SingleElementCollection
      sig { override.returns(String) }
      def collection_name
        'Enumerator'
      end

      sig { params(other: Object).returns(T::Boolean) }
      def ==(other)
        Enumerator === other && element == other.element
      end
    end

    # A hash with known key and value types.
    class Hash < Type
      sig { params(key: TypeLike, value: TypeLike).void }
      def initialize(key, value)
        @key = to_type(key)
        @value = to_type(value)
      end

      sig { params(other: Object).returns(T::Boolean) }
      def ==(other)
        Hash === other && key == other.key && value == other.value
      end

      sig { returns(Type) }
      attr_reader :key

      sig { returns(Type) }
      attr_reader :value

      sig { override.returns(String) }
      def generate_rbi
        "T::Hash[#{key.generate_rbi}, #{value.generate_rbi}]"
      end

      sig { override.returns(String) }
      def generate_rbs
        "::Hash[#{key.generate_rbs}, #{value.generate_rbs}]"
      end

      sig { override.returns(String) }
      def describe
        "Hash<#{key.describe}, #{value.describe}>"
      end
    end

    # A record/shape; a hash with a fixed set of keys with given types.
    class Record < Type
      sig { params(keys_to_types: T::Hash[Symbol, TypeLike]).void }
      def initialize(keys_to_types)
        @keys_to_types = keys_to_types.map do |k, v|
          [k, to_type(v)]
        end.to_h
      end

      sig { params(other: Object).returns(T::Boolean) }
      def ==(other)
        Record === other && keys_to_types == other.keys_to_types
      end

      sig { returns(T::Hash[Symbol, Type]) }
      attr_reader :keys_to_types

      sig { override.returns(String) }
      def generate_rbi
        "{ #{keys_to_types.map { |k, v| "#{k}: #{v.generate_rbi}" }.join(', ')} }"
      end

      sig { override.returns(String) }
      def generate_rbs
        "{ #{keys_to_types.map { |k, v| "#{k}: #{v.generate_rbs}" }.join(', ')} }"
      end

      sig { override.returns(String) }
      def describe
        "{ #{keys_to_types.map { |k, v| "#{k}: #{v.describe}" }.join(', ')} }"
      end
    end

    # A type which represents the class of a type, rather than an instance.
    # For example, "String" means an instance of String, but "Class(String)"
    # means the actual String class.
    class Class < Type
      sig { params(type: TypeLike).void }
      def initialize(type)
        @type = to_type(type)
      end

      sig { params(other: Object).returns(T::Boolean) }
      def ==(other)
        Class === other && type == other.type
      end

      sig { returns(Type) }
      attr_reader :type

      sig { override.returns(String) }
      def generate_rbi
        "T.class_of(#{type.generate_rbi})"
      end

      sig { override.returns(String) }
      def generate_rbs
        "singleton(#{type.generate_rbs})"
      end

      sig { override.returns(String) }
      def describe
        "Class<#{type.describe}>"
      end
    end

    # Type for a boolean.
    class Boolean < Type
      sig { params(other: Object).returns(T::Boolean) }
      def ==(other)
        Boolean === other
      end

      sig { override.returns(String) }
      def generate_rbi
        "T::Boolean"
      end

      sig { override.returns(String) }
      def generate_rbs
        "bool"
      end

      sig { override.returns(String) }
      def describe
        "bool"
      end
    end

    # Type equivalent to the receiver.
    class Self < Type
      sig { params(other: Object).returns(T::Boolean) }
      def ==(other)
        Self === other
      end

      sig { override.returns(String) }
      def generate_rbi
        "T.self_type"
      end

      sig { override.returns(String) }
      def generate_rbs
        "self"
      end

      sig { override.returns(String) }
      def describe
        "self"
      end
    end

    # The explicit lack of a type.
    class Untyped < Type
      sig { params(other: Object).returns(T::Boolean) }
      def ==(other)
        Untyped === other
      end

      sig { override.returns(String) }
      def generate_rbi
        "T.untyped"
      end

      sig { override.returns(String) }
      def generate_rbs
        "untyped"
      end

      sig { override.returns(String) }
      def describe
        "untyped"
      end
    end

    # A type which can be called as a function.
    class Proc < Type
      # A parameter to a proc.
      class Parameter
        extend T::Sig

        sig { params(name: String, type: TypeLike, default: T.nilable(String)).void }
        def initialize(name, type, default = nil)
          @name = name
          @type = Type.to_type(type)
          @default = default
        end

        sig { returns(String) }
        attr_reader :name

        sig { returns(Type) }
        attr_reader :type

        sig { returns(T.nilable(String)) }
        attr_reader :default

        sig { params(other: Object).returns(T::Boolean) }
        def ==(other)
          Parameter === other && name == other.name && type == other.type &&
            default == other.default
        end
      end

      sig { params(parameters: T::Array[Parameter], return_type: T.nilable(TypeLike)).void }
      def initialize(parameters, return_type)
        @parameters = parameters
        @return_type = return_type && to_type(return_type)
      end

      sig { params(other: Object).returns(T::Boolean) }
      def ==(other)
        Proc === other && parameters == other.parameters && return_type == other.return_type
      end

      sig { returns(T::Array[Parameter]) }
      attr_reader :parameters

      sig { returns(T.nilable(Type)) }
      attr_reader :return_type

      sig { override.returns(String) }
      def generate_rbi
        rbi_params = parameters.map do |param|
          RbiGenerator::Parameter.new(param.name, type: param.type, default: param.default)
        end
        "T.proc." +
          (rbi_params.empty? ? "" : "params(#{rbi_params.map(&:to_sig_param).join(', ')}).") +
          (@return_type ? "returns(#{@return_type.generate_rbi})" : 'void')
      end

      sig { override.returns(String) }
      def generate_rbs
        rbs_params = parameters.map do |param|
          RbsGenerator::Parameter.new(param.name, type: param.type, required: param.default.nil?)
        end
        "(#{rbs_params.map(&:to_rbs_param).join(', ')}) -> #{return_type&.generate_rbs || 'void'}"
      end

      sig { override.returns(String) }
      def describe
        # For simplicity, use RBS with pre-described parameter types
        rbs_params = parameters.map do |param|
          RbsGenerator::Parameter.new(param.name, type: param.type.describe, required: param.default.nil?)
        end
        "(#{rbs_params.map(&:to_rbs_param).join(', ')}) -> #{return_type&.describe || 'void'}"
      end
    end
  end
end
