module Polyfill
  module V2_3
    module Prime
      module ClassMethods
        def prime?(*args)
          value = args.first
          unless value.is_a?(::Integer)
            raise ArgumentError, "Expected an integer, got #{value}"
          end

          super
        end
      end
    end
  end
end
