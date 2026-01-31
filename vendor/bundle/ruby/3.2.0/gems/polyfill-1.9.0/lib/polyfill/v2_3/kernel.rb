module Polyfill
  module V2_3
    module Kernel
      def loop
        return super unless block_given?

        super do
          begin
            yield
          rescue StopIteration => enum
            break enum.result
          end
        end
      end
    end
  end
end
