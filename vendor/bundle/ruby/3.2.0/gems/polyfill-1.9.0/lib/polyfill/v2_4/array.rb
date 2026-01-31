require_relative 'numeric'

module Polyfill
  module V2_4
    module Array
      using Polyfill(Numeric: %w[#dup], version: '2.4')

      def concat(*others)
        return super if others.length == 1

        acc = [].concat(self)
        others.each do |other|
          acc.concat(other)
        end

        replace(acc)
      end

      def sum(init = 0)
        acc = init.dup

        for i in 0..(size - 1) # rubocop:disable Style/For
          elem = self[i]
          acc += block_given? ? yield(elem) : elem
        end

        acc
      end
    end
  end
end
