module Polyfill
  module V2_4
    module Enumerator
      module Lazy
        using Polyfill(Enumerable: %w[#chunk_while], version: '2.4')

        def chunk_while
          super.lazy
        end

        def uniq
          seen = Set.new

          ::Enumerator::Lazy.new(self) do |yielder, *values|
            result = block_given? ? yield(*values) : values

            yielder.<<(*values) if seen.add?(result)
          end
        end
      end
    end
  end
end
