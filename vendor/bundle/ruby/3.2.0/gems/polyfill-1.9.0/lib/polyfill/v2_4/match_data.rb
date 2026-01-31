module Polyfill
  module V2_4
    module MatchData
      def named_captures
        names.each_with_object({}) do |name, acc|
          acc[name] = self[name]
        end
      end

      def values_at(*indexes)
        indexes.each_with_object([]) do |index, acc|
          acc.push(self[index])
        end
      end
    end
  end
end
