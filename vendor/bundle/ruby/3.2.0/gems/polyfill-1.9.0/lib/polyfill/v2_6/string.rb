module Polyfill
  module V2_6
    module String
      def split(*)
        result = super

        if block_given?
          result.each(&::Proc.new)
          self
        else
          result
        end
      end
    end
  end
end
