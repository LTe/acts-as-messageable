module Polyfill
  module V2_4
    module Comparable
      def clamp(min, max)
        if min > max
          raise ArgumentError, 'min argument must be smaller than max argument'
        end

        return min if min > self
        return max if max < self
        self
      end
    end
  end
end
