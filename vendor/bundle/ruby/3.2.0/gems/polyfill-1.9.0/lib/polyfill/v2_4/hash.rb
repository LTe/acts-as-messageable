module Polyfill
  module V2_4
    module Hash
      def compact
        reject { |_, v| v.nil? }
      end

      def compact!
        reject! { |_, v| v.nil? }
      end

      def transform_values
        unless block_given?
          return ::Enumerator.new(keys.size) do |yielder|
            each_with_object({}) do |(k, v), acc|
              acc[k] = yielder.yield(v)
            end
          end
        end

        each_with_object({}) do |(k, v), acc|
          acc[k] = yield(v)
        end
      end

      def transform_values!
        unless block_given?
          return ::Enumerator.new(keys.size) do |yielder|
            replace(each_with_object({}) do |(k, v), acc|
              acc[k] = yielder.yield(v)
            end)
          end
        end

        replace(each_with_object({}) do |(k, v), acc|
          acc[k] = yield(v)
        end)
      end
    end
  end
end
