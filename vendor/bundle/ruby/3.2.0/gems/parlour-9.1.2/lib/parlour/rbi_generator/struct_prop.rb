# typed: true
module Parlour
  class RbiGenerator < Generator
    # Represents a +T::Struct+ property.
    class StructProp
      extend T::Sig

      sig do
        params(
          name: String,
          type: Types::TypeLike,
          optional: T.nilable(T.any(T::Boolean, Symbol)),
          enum: T.nilable(String),
          dont_store: T.nilable(T::Boolean),
          foreign: T.nilable(String),
          default: T.nilable(String),
          factory: T.nilable(String),
          immutable: T.nilable(T::Boolean),
          array: T.nilable(String),
          override: T.nilable(T::Boolean),
          redaction: T.nilable(String),
        ).void
      end
      # Create a new struct property.
      #
      # For documentation on all optional properties, please refer to the
      # documentation for T::Struct within the sorbet-runtime gem:
      # https://github.com/sorbet/sorbet/blob/master/gems/sorbet-runtime/lib/types/props/_props.rb#L31-L106
      #
      # @param name [String] The name of this property.
      # @param type [String] This property's type.
      # @return [void]
      def initialize(name, type, optional: nil, enum: nil, dont_store: nil,
        foreign: nil, default: nil, factory: nil, immutable: nil, array: nil,
        override: nil, redaction: nil)
        
        @name = name
        @type = type
        @optional = optional
        @enum = enum
        @dont_store = dont_store
        @foreign = foreign
        @default = default
        @factory = factory
        @immutable = immutable
        @array = array
        @override = override
        @redaction = redaction
      end

      sig { params(other: Object).returns(T::Boolean) }
      # Returns true if this instance is equal to another instance.
      #
      # @param other [Object] The other instance. If this is not a {StructProp} (or a
      #   subclass of it), this will always return false.
      # @return [Boolean]
      def ==(other)
        StructProp === other &&
          name       == other.name &&
          type       == other.type &&
          optional   == other.optional &&
          enum       == other.enum &&
          dont_store == other.dont_store &&
          foreign    == other.foreign &&
          default    == other.default &&
          factory    == other.factory &&
          immutable  == other.immutable &&
          array      == other.array &&
          override   == other.override &&
          redaction  == other.redaction
      end

      sig { returns(String) }
      # The name of this parameter, including any prefixes or suffixes such as
      # +*+.
      # @return [String]
      attr_reader :name

      sig { returns(Types::TypeLike) }
      # This parameter's type.
      # @return [Types::TypeLike, nil]
      attr_reader :type

      sig { returns(T.nilable(T.any(T::Boolean, Symbol))) }
      attr_reader :optional

      sig { returns(T.nilable(String)) }
      attr_reader :enum

      sig { returns(T.nilable(T::Boolean)) }
      attr_reader :dont_store

      sig { returns(T.nilable(String)) }
      attr_reader :foreign

      sig { returns(T.nilable(String)) }
      attr_reader :default

      sig { returns(T.nilable(String)) }
      attr_reader :factory

      sig { returns(T.nilable(T::Boolean)) }
      attr_reader :immutable

      sig { returns(T.nilable(String)) }
      attr_reader :array

      sig { returns(T.nilable(T::Boolean)) }
      attr_reader :override

      sig { returns(T.nilable(String)) }
      attr_reader :redaction

      # The optional properties available on instances of this class.
      EXTRA_PROPERTIES = T.let(%i{
        optional enum dont_store foreign default factory immutable array override redaction
      }, T::Array[Symbol])

      sig { returns(String) }
      # Returns the +prop+ call required to create this property.
      # @return [String]
      def to_prop_call
        call = "prop :#{name}, #{String === @type ? @type : @type.generate_rbi}"

        EXTRA_PROPERTIES.each do |extra_property|
          value = send extra_property
          call += ", #{extra_property}: #{value}" unless value.nil?
        end

        call
      end

      sig { void }
      def generalize_from_rbi!
        @type = TypeParser.parse_single_type(@type) if String === @type
      end
    end
  end
end
