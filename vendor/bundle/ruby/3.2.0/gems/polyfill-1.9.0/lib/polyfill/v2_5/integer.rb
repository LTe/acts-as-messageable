require 'bigdecimal'

module Polyfill
  module V2_5
    module Integer
      using Polyfill(Integer: %w[#ceil #floor #round #truncate], version: '2.4')

      module ClassMethods
        def sqrt(n)
          n = InternalUtils.to_int(n)
          if n < 0
            raise Math::DomainError, 'Numerical argument is out of domain - "isqrt"'
          end

          res = 0
          bit = 1 << ((n.size * 8) - 2)

          bit >>= 2 while bit > n

          while bit != 0
            res_bit = res + bit
            if n >= res_bit
              n -= res_bit
              res = (res >> 1) + bit
            else
              res >>= 1
            end

            bit >>= 2
          end

          res
        end
      end

      def ceil(*)
        super.to_i
      end

      def floor(*)
        super.to_i
      end

      def round(*)
        super.to_i
      end

      def truncate(*)
        super.to_i
      end

      def allbits?(mask)
        imask = InternalUtils.to_int(mask)
        self & imask == imask
      end

      def anybits?(mask)
        self & InternalUtils.to_int(mask) != 0
      end

      def nobits?(mask)
        self & InternalUtils.to_int(mask) == 0
      end
    end
  end
end
