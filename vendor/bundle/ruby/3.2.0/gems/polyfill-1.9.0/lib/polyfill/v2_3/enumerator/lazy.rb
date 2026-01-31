module Polyfill
  module V2_3
    module Enumerator
      module Lazy
        def grep_v(pattern)
          ::Enumerator::Lazy.new(self) do |yielder, element|
            next if pattern === element # rubocop:disable Style/CaseEquality

            yielder << (block_given? ? yield(element) : element)
          end
        end
      end
    end
  end
end
