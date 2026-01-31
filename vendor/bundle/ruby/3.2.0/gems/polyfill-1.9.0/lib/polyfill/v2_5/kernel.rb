module Polyfill
  module V2_5
    module Kernel
      def yield_self
        unless block_given?
          return ::Enumerator.new(1) do |yielder|
            yielder.yield(self)
          end
        end

        yield(self)
      end
    end
  end
end
