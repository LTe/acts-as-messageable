module Polyfill
  module V2_4
    module Regexp
      def match?(string, position = 0)
        !!(string[position..-1] =~ self)
      end
    end
  end
end
