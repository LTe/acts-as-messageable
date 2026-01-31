module Polyfill
  module V2_4
    module Numeric
      def clone(freeze: true) # rubocop:disable Lint/UnusedMethodArgument
        self
      end

      def dup
        self
      end

      def finite?
        true
      end

      def infinite?
        nil
      end
    end
  end
end
