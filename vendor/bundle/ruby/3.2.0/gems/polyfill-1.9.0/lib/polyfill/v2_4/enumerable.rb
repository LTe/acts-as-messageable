require_relative 'numeric'

module Polyfill
  module V2_4
    module Enumerable
      using Polyfill(Numeric: %w[#dup], version: '2.4')

      def chunk(*)
        return enum_for(:chunk) unless block_given?

        super
      end

      def sum(init = 0)
        acc = init.dup

        each do |elem|
          acc += block_given? ? yield(elem) : elem
        end

        acc
      end

      def uniq
        if block_given?
          to_a.uniq(&::Proc.new)
        else
          to_a.uniq
        end
      end
    end
  end
end
