# typed: true

module Parlour
  class ParseError < StandardError
    extend T::Sig

    sig { returns(Parser::Source::Buffer) }
    attr_reader :buffer

    sig { returns(Parser::Source::Range) }
    attr_reader :range

    def initialize(buffer, range)
      super()
      @buffer = buffer
      @range = range
    end
  end
end
