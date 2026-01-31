module Polyfill
  module V2_3
    module Numeric
      def negative?
        self < 0
      end

      def positive?
        self > 0
      end
    end
  end
end
