module Polyfill
  module V2_2
    module Prime
      module ClassMethods
        def prime?(*args)
          value = args.first
          return false if value < 0

          super
        end
      end
    end
  end
end
