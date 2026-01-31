module Polyfill
  module V2_3
    module Hash
      def <(other)
        other = InternalUtils.to_hash(other)

        return false if size == other.size

        all? { |k, v| other[k] == v }
      end

      def <=(other)
        other = InternalUtils.to_hash(other)

        all? { |k, v| other[k] == v }
      end

      def >(other)
        other = InternalUtils.to_hash(other)

        return false if size == other.size

        other.all? { |k, v| self[k] == v }
      end

      def >=(other)
        other = InternalUtils.to_hash(other)

        other.all? { |k, v| self[k] == v }
      end

      def dig(head, *rest)
        [head, *rest].reduce(self) do |value, accessor|
          next_value =
            case value
            when ::Array
              value.at(accessor)
            when ::Hash
              value[accessor]
            when ::Struct
              value[accessor] if value.members.include?(accessor)
            else
              begin
                break value.dig(*rest)
              rescue NoMethodError
                raise TypeError, "#{value.class} does not have a #dig method"
              end
            end

          break nil if next_value.nil?
          next_value
        end
      end

      def fetch_values(*keys)
        if block_given?
          block = ::Proc.new

          keys.each_with_object([]) do |key, values|
            values << fetch(key, &block)
          end
        else
          keys.each_with_object([]) do |key, values|
            values << fetch(key)
          end
        end
      end

      def to_proc
        method(:[]).to_proc
      end
    end
  end
end
