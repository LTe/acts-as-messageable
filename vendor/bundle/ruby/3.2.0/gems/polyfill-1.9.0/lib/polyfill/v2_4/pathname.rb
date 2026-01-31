module Polyfill
  module V2_4
    module Pathname
      def empty?
        if directory?
          children.empty?
        else
          zero?
        end
      end
    end
  end
end
