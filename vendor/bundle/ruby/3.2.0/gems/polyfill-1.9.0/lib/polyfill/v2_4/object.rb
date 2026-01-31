module Polyfill
  module V2_4
    module Object
      def clone(freeze: true)
        return super() if freeze

        cloned = dup
        (singleton_class.ancestors - self.class.ancestors).drop(1).each do |ancestor|
          cloned.extend(ancestor)
        end
        cloned
      end
    end
  end
end
