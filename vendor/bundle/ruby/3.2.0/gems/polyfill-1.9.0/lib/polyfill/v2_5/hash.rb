module Polyfill
  module V2_5
    module Hash
      def slice(*keys)
        keys.each_with_object({}) do |k, acc|
          acc[k] = self[k] if key?(k)
        end
      end

      def transform_keys
        unless block_given?
          return ::Enumerator.new(keys.size) do |yielder|
            each_with_object({}) do |(k, v), acc|
              acc[yielder.yield(k)] = v
            end
          end
        end

        each_with_object({}) do |(k, v), acc|
          acc[yield(k)] = v
        end
      end
    end
  end
end
