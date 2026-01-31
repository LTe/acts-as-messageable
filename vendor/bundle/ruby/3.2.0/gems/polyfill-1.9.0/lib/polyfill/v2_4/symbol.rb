module Polyfill
  module V2_4
    module Symbol
      def casecmp?(other)
        return nil unless other.is_a?(::Symbol)

        casecmp(other) == 0
      end

      def match(*args)
        if block_given?
          to_s.match(*args, &::Proc.new)
        else
          to_s.match(*args)
        end
      end

      def match?(pattern, position = 0)
        !!(self[position..-1] =~ pattern)
      end
    end
  end
end
