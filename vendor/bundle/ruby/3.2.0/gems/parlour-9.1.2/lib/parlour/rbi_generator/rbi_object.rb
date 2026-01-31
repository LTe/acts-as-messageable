# typed: true
module Parlour
  class RbiGenerator < Generator
    # An abstract class which is subclassed by any classes which can generate
    # entire lines of an RBI, such as {Namespace} and {Method}. (As an example,
    # {Parameter} is _not_ a subclass because it does not generate lines, only
    # segments of definition and signature lines.)
    # 
    # This class is *abstract*.
    class RbiObject < TypedObject
      abstract!
      
      sig { params(generator: Generator, name: String).void }
      # Creates a new RBI object.
      # @note Don't call this directly.
      #
      # @param generator [RbiGenerator] The current RbiGenerator.
      # @param name [String] The name of this module.
      # @return [void]
      def initialize(generator, name)
        super(name)
        @generator = generator
        @generated_by = RbiGenerator === generator ? generator.current_plugin : nil
      end

      sig { returns(Generator) }
      # The generator which this object belongs to.
      # @return [Generator]
      attr_reader :generator

      sig do
        abstract.params(
          indent_level: Integer,
          options: Options
        ).returns(T::Array[String])
      end
      # Generates the RBI lines for this object.
      #
      # This method is *abstract*.
      #
      # @param indent_level [Integer] The indentation level to generate the lines at.
      # @param options [Options] The formatting options to use.
      # @return [Array<String>] The RBI lines, formatted as specified.
      def generate_rbi(indent_level, options); end

      sig do
        abstract.params(
          others: T::Array[RbiGenerator::RbiObject]
        ).returns(T::Boolean)
      end
      # Given an array of other objects, returns true if they may be merged
      # into this instance using {merge_into_self}. Each subclass will have its
      # own criteria on what allows objects to be mergeable.
      #
      # This method is *abstract*.
      #
      # @param others [Array<RbiGenerator::RbiObject>] An array of other {RbiObject} instances.
      # @return [Boolean] Whether this instance may be merged with them.
      def mergeable?(others); end

      sig do 
        abstract.params(
          others: T::Array[RbiGenerator::RbiObject]
        ).void
      end
      # Given an array of other objects, merges them into this one. Each
      # subclass will do this differently.
      # You MUST ensure that {mergeable?} is true for those instances.
      #
      # This method is *abstract*.
      #
      # @param others [Array<RbiGenerator::RbiObject>] An array of other {RbiObject} instances.
      # @return [void]
      def merge_into_self(others); end

      sig { abstract.void }
      # Assuming that the types throughout this object and its children have
      # been specified as RBI-style types, generalises them into type instances
      # from the {Parlour::Types} module.
      #
      # This method is *abstract*.
      #
      # @return [void]
      def generalize_from_rbi!; end
    end
  end
end
