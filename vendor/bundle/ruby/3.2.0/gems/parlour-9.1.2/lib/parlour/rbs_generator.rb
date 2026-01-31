# typed: true
module Parlour
  # The RBS generator.
  class RbsGenerator < Generator  
    def initialize(**hash)
      super
      @root = RbsGenerator::Namespace.new(self)
    end

    sig { overridable.returns(RbsGenerator::Namespace) }
    # The root {Namespace} of this generator.
    # @return [Namespace]
    attr_reader :root
    
    sig { overridable.returns(String) }
    # Returns the complete contents of the generated RBS file as a string.
    #
    # @return [String] The generated RBS file
    def rbs
      root.generate_rbs(0, options).join("\n")
    end
  end
  end
  