# frozen_string_literal: true

module RuboCop
  module Cop
    module Sorbet
      # Mixin for writing cops for signatures, providing a `signature?` node matcher and an `on_signature` trigger.
      module SignatureHelp
        extend RuboCop::NodePattern::Macros

        # @!method signature?(node)
        def_node_matcher(:signature?, <<~PATTERN)
          (block (send
            {nil? #with_runtime? #without_runtime?}
            :sig
            (sym :final)?
          ) (args) ...)
        PATTERN

        # @!method with_runtime?(node)
        def_node_matcher(:with_runtime?, <<~PATTERN)
          (const (const {nil? cbase} :T) :Sig)
        PATTERN

        # @!method without_runtime?(node)
        def_node_matcher(:without_runtime?, <<~PATTERN)
          (const (const (const {nil? cbase} :T) :Sig) :WithoutRuntime)
        PATTERN

        def on_block(node)
          on_signature(node) if signature?(node)
        end

        alias_method :on_numblock, :on_block

        def on_signature(_node)
          # To be defined by cop class as needed
        end
      end
    end
  end
end
