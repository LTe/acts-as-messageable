module Polyfill
  module V2_5
    module Array
      def append(*args)
        push(*args)
      end

      def prepend(*args)
        unshift(*args)
      end
    end
  end
end
