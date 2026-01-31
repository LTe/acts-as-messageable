module Polyfill
  module V2_3
    module Struct
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
    end
  end
end
