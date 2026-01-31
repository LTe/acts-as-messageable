module Polyfill
  module V2_5
    module Enumerable
      def all?(*pattern)
        return super if pattern.empty?

        grep(*pattern).size == size
      end

      def any?(*pattern)
        return super if pattern.empty?

        !grep(*pattern).empty?
      end

      def none?(*pattern)
        return super if pattern.empty?

        grep(*pattern).empty?
      end

      def one?(*pattern)
        return super if pattern.empty?

        grep(*pattern).size == 1
      end
    end
  end
end
