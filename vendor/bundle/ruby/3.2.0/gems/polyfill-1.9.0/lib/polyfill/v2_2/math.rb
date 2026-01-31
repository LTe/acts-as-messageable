module Polyfill
  module V2_2
    module Math
      module ClassMethods
        def log(*args)
          if (base = args[1])
            base = InternalUtils.to_f(base)
            raise ::Math::DomainError, 'Numerical argument is out of domain - "log"' if base < 0

            x = args[0]
            return 0 / 0.0 if base == 0 && InternalUtils.to_f(x) == 0
          end

          super
        end
      end
    end
  end
end
