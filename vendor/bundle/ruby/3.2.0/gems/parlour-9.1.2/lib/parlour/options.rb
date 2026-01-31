# typed: true
module Parlour
  # A set of immutable formatting options.
  class Options
    extend T::Sig

    sig { params(break_params: Integer, tab_size: Integer, sort_namespaces: T::Boolean).void }
    # Creates a new set of formatting options.
    #
    # @example Create Options with +break_params+ of +4+ and +tab_size+ of +2+.
    #   Parlour::Options.new(break_params: 4, tab_size: 2)
    #
    # @param break_params [Integer] If there are at least this many parameters in a 
    #   signature, then it is broken onto separate lines.
    # @param tab_size [Integer] The number of spaces to use per indent.
    # @param sort_namespaces [Boolean] Whether to sort all items within a
    #   namespace alphabetically.
    # @return [void]
    def initialize(break_params:, tab_size:, sort_namespaces:)
      @break_params = break_params
      @tab_size = tab_size
      @sort_namespaces = sort_namespaces
    end
    
    sig { returns(Integer) }
    # If there are at least this many parameters in a signature, then it 
    # is broken onto separate lines.
    #
    #   # With break_params: 5
    #   sig { params(name: String, age: Integer, hobbies: T::Array(String), country: Symbol).void }
    #
    #   # With break_params: 4
    #   sig do
    #     params(
    #       name: String,
    #       age: Integer,
    #       hobbies: T::Array(String),
    #       country: Symbol
    #     ).void
    #   end
    #
    # @return [Integer]
    attr_reader :break_params

    sig { returns(Integer) }
    # The number of spaces to use per indent.
    # @return [Integer]
    attr_reader :tab_size

    sig { returns(T::Boolean) }
    # Whether to sort all items within a namespace alphabetically.
    # Items which are typically grouped together, such as "include" or
    # "extend" calls, will remain grouped together when sorted.
    # If true, items are sorted by their name when the RBI is generated.
    # If false, items are generated in the order they are added to the
    # namespace.
    # @return [Boolean]
    attr_reader :sort_namespaces

    sig { params(level: Integer, str: String).returns(String) }
    # Returns a string indented to the given indent level, according to the
    # set {tab_size}.
    #
    # @param level [Integer] The indent level, as an integer. 0 is totally unindented.
    # @param str [String] The string to indent.
    # @return [String] The indented string.
    def indented(level, str)
      " " * (level * tab_size) + str
    end
  end
end
