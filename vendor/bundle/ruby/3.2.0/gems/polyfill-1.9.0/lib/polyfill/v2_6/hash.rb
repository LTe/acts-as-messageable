module Polyfill
  module V2_6
    module Hash
      def to_h
        return super unless block_given?

        block = ::Proc.new

        pairs = map do |k, v|
          pair = block.call(k, v)

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

      def merge(*args)
        if block_given?
          args.each_with_object(dup) do |arg, h|
            h.merge!(arg, &::Proc.new)
          end
        else
          args.each_with_object(dup) do |arg, h|
            h.merge!(arg)
          end
        end
      end

      def merge!(*args)
        if block_given?
          args.each_with_object(self) do |arg, h|
            h.merge!(arg, &::Proc.new)
          end
        else
          args.each_with_object(self) do |arg, h|
            h.merge!(arg)
          end
        end
      end

      def update(*args)
        if block_given?
          args.each_with_object(self) do |arg, h|
            h.update(arg, &::Proc.new)
          end
        else
          args.each_with_object(self) do |arg, h|
            h.update(arg)
          end
        end
      end
    end
  end
end
