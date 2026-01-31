module Polyfill
  module V2_6
    module Array
      def difference(*arrays)
        arrays.reduce([*self]) do |me, array|
          me - array
        end
      end

      def to_h
        return super unless block_given?

        block = ::Proc.new

        pairs = map.with_index do |elem, i|
          pair = block.call(elem)

          unless pair.respond_to?(:to_ary)
            raise TypeError, "wrong element type #{pair.class} at #{i} (expected array)"
          end

          pair = pair.to_ary

          unless pair.length == 2
            raise ArgumentError, "wrong array length at #{i} (expected 2, was #{pair.length})"
          end

          pair
        end

        pairs.to_h
      end

      def union(*arrays)
        return self | [] if arrays.empty?

        arrays.reduce(self) do |me, array|
          me | array
        end
      end
    end
  end
end
