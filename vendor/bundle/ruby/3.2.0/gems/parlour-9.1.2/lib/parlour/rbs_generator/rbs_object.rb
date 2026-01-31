# typed: true
module Parlour
  class RbsGenerator < Generator
    # An abstract class which is subclassed by any classes which can generate
    # entire lines of an RBS, such as {Namespace} and {Method}. (As an example,
    # {Parameter} is _not_ a subclass because it does not generate lines, only
    # segments of definition lines.)
    #
    # This class is *abstract*.
    class RbsObject < TypedObject
      abstract!
      
      sig { params(generator: Generator, name: String).void }
      # Creates a new RBS object.
      # @note Don't call this directly.
      #
      # @param generator [RbsGenerator] The current RbsGenerator.
      # @param name [String] The name of this module.
      # @return [void]
      def initialize(generator, name)
        super(name)
        @generator = generator
        @generated_by = RbsGenerator === generator ? generator.current_plugin : nil
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
      # Generates the RBS lines for this object.
      #
      # This method is *abstract*.
      #
      # @param indent_level [Integer] The indentation level to generate the lines at.
      # @param options [Options] The formatting options to use.
      # @return [Array<String>] The RBS lines, formatted as specified.
      def generate_rbs(indent_level, options); end

      sig do
        abstract.params(
          others: T::Array[RbsGenerator::RbsObject]
        ).returns(T::Boolean)
      end
      # Given an array of other objects, returns true if they may be merged
      # into this instance using {merge_into_self}. Each subclass will have its
      # own criteria on what allows objects to be mergeable.
      #
      # This method is *abstract*.
      #
      # @param others [Array<RbsGenerator::RbsObject>] An array of other {RbsObject} instances.
      # @return [Boolean] Whether this instance may be merged with them.
      def mergeable?(others); end

      sig do 
        abstract.params(
          others: T::Array[RbsGenerator::RbsObject]
        ).void
      end
      # Given an array of other objects, merges them into this one. Each
      # subclass will do this differently.
      # You MUST ensure that {mergeable?} is true for those instances.
      #
      # This method is *abstract*.
      #
      # @param others [Array<RbsGenerator::RbsObject>] An array of other {RbsObject} instances.
      # @return [void]
      def merge_into_self(others); end
    end
  end
end
