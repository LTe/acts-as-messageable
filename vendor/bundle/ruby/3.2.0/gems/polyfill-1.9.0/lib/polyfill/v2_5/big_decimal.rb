module Polyfill
  module V2_5
    module BigDecimal
      def clone
        self
      end

      def dup
        self
      end
    end
  end
end
