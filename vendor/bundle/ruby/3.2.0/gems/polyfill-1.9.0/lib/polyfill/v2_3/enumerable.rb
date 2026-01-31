module Polyfill
  module V2_3
    module Enumerable
      def chunk_while
        block = ::Proc.new

        ::Enumerator.new do |yielder|
          output = []
          each do |element, *rest|
            elements = rest.any? ? [element, *rest] : element

            if output.empty? || block.call(output.last, elements)
              output.push(elements)
            else
              yielder << output
              output = [elements]
            end
          end
          yielder << output unless output.empty?
        end
      end

      def grep_v(pattern)
        output = to_a - grep(pattern)
        output.map!(&::Proc.new) if block_given?
        output
      end

      def slice_before(*args)
        if !args.empty? && block_given?
          raise ArgumentError, 'wrong number of arguments (given 1, expected 0)'
        end

        super
      end
    end
  end
end
