module Polyfill
  module V2_5
    module String
      def casecmp(other_str)
        super
      rescue TypeError
        nil
      end

      def casecmp?(other_str)
        super
      rescue TypeError
        nil
      end

      def delete_prefix(prefix)
        sub(/\A#{InternalUtils.to_str(prefix)}/, ''.freeze)
      end

      def delete_prefix!(prefix)
        prev = dup
        current = sub!(/\A#{InternalUtils.to_str(prefix)}/, ''.freeze)
        prev == current ? nil : current
      end

      def delete_suffix(suffix)
        chomp(suffix)
      end

      def delete_suffix!(suffix)
        chomp!(suffix)
      end

      def start_with?(*prefixes)
        super if prefixes.grep(Regexp).empty?

        prefixes.any? do |prefix|
          prefix.is_a?(Regexp) ? self[/\A#{prefix}/] : super(prefix)
        end
      end

      def grapheme_clusters
        return scan(/\X/, &::Proc.new) if block_given?

        scan(/\X/)
      end

      def each_grapheme_cluster
        unless block_given?
          grapheme_clusters = scan(/\X/)

          return ::Enumerator.new(grapheme_clusters.size) do |yielder|
            grapheme_clusters.each do |grapheme_cluster|
              yielder.yield(grapheme_cluster)
            end
          end
        end

        scan(/\X/, &::Proc.new)
      end
    end
  end
end
