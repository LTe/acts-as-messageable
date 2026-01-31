module Polyfill
  module V2_4
    module Integer
      def ceil(ndigits = 0)
        ndigits = InternalUtils.to_int(ndigits)
        return super() if ndigits == 0
        return to_f if ndigits > 0

        place = 10**-ndigits
        (to_f / place).ceil * place
      end

      def digits(base = 10)
        base = InternalUtils.to_int(base)
        raise Math::DomainError, 'out of domain' if self < 0
        raise ArgumentError, 'negative radix' if base < 0
        raise ArgumentError, "invalid radix #{base}" if base < 2

        acc = []
        remainder = self
        while remainder > 0
          remainder, value = remainder.divmod(base)
          acc.push(value)
        end
        acc
      end

      def floor(ndigits = 0)
        ndigits = InternalUtils.to_int(ndigits)
        return super() if ndigits == 0
        return to_f if ndigits > 0

        place = 10**-ndigits
        (to_f / place).floor * place
      end

      def round(ndigits = 0, half: nil)
        unless [nil, :down, :even, :up, 'down', 'even', 'up'].include?(half)
          raise ArgumentError, "invalid rounding mode: #{half}"
        end
        ndigits = InternalUtils.to_int(ndigits)
        return super() if ndigits == 0
        return to_f if ndigits > 0

        place = 10**-ndigits
        (to_f / place).round * place
      end

      def truncate(ndigits = 0)
        ndigits = InternalUtils.to_int(ndigits)
        return super() if ndigits == 0
        return to_f if ndigits > 0

        place = 10**-ndigits
        (to_f / place).truncate * place
      end
    end
  end
end
