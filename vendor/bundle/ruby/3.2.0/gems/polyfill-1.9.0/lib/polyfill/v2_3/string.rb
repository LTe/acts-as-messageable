module Polyfill
  module V2_3
    module String
      module ClassMethods
        def new(*args)
          hash, others = args.partition { |arg| arg.is_a?(::Hash) }
          hash = hash.first
          encoding = hash && hash.delete(:encoding)

          if hash && !hash.keys.empty?
            raise ArgumentError, "unknown keyword: #{hash.keys.first}"
          end

          str = super(*others)
          str.force_encoding(encoding) if encoding
          str
        end
      end

      def +@
        frozen? ? dup : self
      end

      def -@
        frozen? ? self : dup.freeze
      end
    end
  end
end
