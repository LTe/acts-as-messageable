module Polyfill
  module V2_6
    module Enumerable
      def to_h
        return super unless block_given?

        block = ::Proc.new

        pairs = map do |elem|
          pair = block.call(elem)

          unless pair.respond_to?(:to_ary)
            raise TypeError, "wrong element type #{pair.class} (expected array)"
          end

          pair = pair.to_ary

          unless pair.length == 2
            raise ArgumentError, "element has wrong array length (expected 2, was #{pair.length})"
          end

          pair
        end

        pairs.to_h
      end
    end
  end
end
