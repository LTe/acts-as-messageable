# typed: true
require 'rainbow'

module Parlour
  module Conversion
    # An abstract class which converts between the node trees of two type
    # systems.
    class Converter
      extend T::Sig
      extend T::Helpers
      abstract!

      def initialize
        @warnings = []
      end

      sig { returns(T::Array[[String, TypedObject]]) }
      attr_reader :warnings

      sig { params(msg: String, node: RbiGenerator::RbiObject).void }
      def add_warning(msg, node)
        warnings << [msg, node]

        return if $VERBOSE.nil?
        class_name = T.must(self.class.name).split('::').last
        print Rainbow("Parlour warning: ").yellow.dark.bold
        print Rainbow("#{class_name}: ").magenta.bright.bold
        puts msg
        print Rainbow("    └ at object: ").blue.bright.bold
        puts node.describe
      end
    end
  end
end