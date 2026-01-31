module Polyfill
  module V2_2
    module Enumerable
      def max(n = nil)
        return block_given? ? super(&::Proc.new) : super() if n.nil? || n == 1

        raise ArgumentError, "negative size (#{n})" if n < 0

        (block_given? ? sort(&::Proc.new) : sort).last(n).reverse
      end

      def max_by(n = nil)
        if n.nil? || n == 1 || !block_given?
          return block_given? ? super(&::Proc.new) : super()
        end

        raise ArgumentError, "negative size (#{n})" if n < 0

        sort_by(&::Proc.new).last(n).reverse
      end

      def min(n = nil)
        return block_given? ? super(&::Proc.new) : super() if n.nil? || n == 1

        raise ArgumentError, "negative size (#{n})" if n < 0

        (block_given? ? sort(&::Proc.new) : sort).first(n)
      end

      def min_by(n = nil)
        if n.nil? || n == 1 || !block_given?
          return block_given? ? super(&::Proc.new) : super()
        end

        raise ArgumentError, "negative size (#{n})" if n < 0

        sort_by(&::Proc.new).first(n)
      end

      def slice_after(pattern = nil)
        raise ArgumentError, 'both pattern and block are given' if pattern && block_given?
        raise ArgumentError, 'wrong number of arguments (given 0, expected 1)' if !pattern && !block_given?

        matcher = pattern || ::Proc.new

        ::Enumerator.new do |yielder|
          output = []
          each do |element, *rest|
            elements = rest.any? ? [element, *rest] : element

            output.push(elements)
            if matcher === output.last # rubocop:disable Style/CaseEquality
              yielder << output
              output = []
            end
          end
          yielder << output unless output.empty?
        end
      end

      def slice_when
        block = ::Proc.new

        ::Enumerator.new do |yielder|
          output = []
          each do |element, *rest|
            elements = rest.any? ? [element, *rest] : element

            if output.empty? || !block.call(output.last, elements)
              output.push(elements)
            else
              yielder << output
              output = [elements]
            end
          end
          yielder << output unless output.empty?
        end
      end
    end
  end
end
