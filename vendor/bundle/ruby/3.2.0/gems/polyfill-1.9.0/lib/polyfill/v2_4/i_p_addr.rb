module Polyfill
  module V2_4
    module IPAddr
      def ==(*)
        super
      rescue ::IPAddr::InvalidAddressError
        false
      end

      def <=>(*)
        super
      rescue ::IPAddr::InvalidAddressError
        nil
      end
    end
  end
end
