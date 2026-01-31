# typed: true
module Parlour
  # The RBI generator.
  class RbiGenerator < Generator
    # For backwards compatibility.
    # Before Parlour 5.0, Parlour::Options was Parlour::RbiGenerator::Options.
    Options = Parlour::Options

    def initialize(**hash)
      super
      @root = RbiGenerator::Namespace.new(self)
    end

    sig { overridable.returns(RbiGenerator::Namespace) }
    # The root {Namespace} of this generator.
    # @return [Namespace]
    attr_reader :root

    sig { overridable.params(strictness: String).returns(String) }
    # Returns the complete contents of the generated RBI file as a string.
    #
    # @return [String] The generated RBI file
    def rbi(strictness = 'strong')
      "# typed: #{strictness}\n" + root.generate_rbi(0, options).join("\n") + "\n"
    end
  end
end
