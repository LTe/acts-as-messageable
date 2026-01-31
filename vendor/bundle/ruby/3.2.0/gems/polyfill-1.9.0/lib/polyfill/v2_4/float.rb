module Polyfill
  module V2_4
    module Float
      def ceil(ndigits = 0)
        ndigits = InternalUtils.to_int(ndigits)
        return super() if ndigits == 0

        if ndigits > 0
          place = 10**ndigits
          (self * place).ceil / place.to_f
        else
          place = 10**-ndigits
          (self / place).ceil * place
        end
      end

      def floor(ndigits = 0)
        ndigits = InternalUtils.to_int(ndigits)
        return super() if ndigits == 0

        if ndigits > 0
          place = 10**ndigits
          (self * place).floor / place.to_f
        else
          place = 10**-ndigits
          (self / place).floor * place
        end
      end

      def truncate(ndigits = 0)
        ndigits = InternalUtils.to_int(ndigits)
        return super() if ndigits == 0

        if ndigits > 0
          place = 10**ndigits
          (self * place).truncate / place.to_f
        else
          place = 10**-ndigits
          (self / place).truncate * place
        end
      end
    end
  end
end
