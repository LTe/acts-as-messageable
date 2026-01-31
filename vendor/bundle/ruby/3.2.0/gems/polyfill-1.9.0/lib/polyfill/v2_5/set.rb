module Polyfill
  module V2_5
    module Set
      def ===(other)
        include?(other)
      end

      def to_s
        inspect
      end
    end
  end
end
