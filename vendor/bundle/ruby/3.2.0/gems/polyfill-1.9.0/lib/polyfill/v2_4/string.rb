require 'English'

module Polyfill
  module V2_4
    module String
      module ClassMethods
        def new(*args)
          hash = args.find { |arg| arg.is_a?(::Hash) }
          hash && hash.delete(:capacity) if hash

          super(*args)
        end
      end

      def casecmp?(other)
        casecmp(InternalUtils.to_str(other)) == 0
      end

      def concat(*others)
        return super if others.length == 1

        acc = '' << self
        others.each do |other|
          acc << other
        end

        replace(acc)
      end

      def each_line(*args)
        hash, others = args.partition { |arg| arg.is_a?(::Hash) }
        chomps = hash[0] && hash[0][:chomp]

        unless block_given?
          return super(*others) unless chomps

          separator = others.find do |other|
            other.respond_to?(:to_str)
          end || $INPUT_RECORD_SEPARATOR
          return ::Enumerator.new do |yielder|
            super(*others) do |line|
              yielder.yield(line.chomp(separator))
            end
          end
        end

        block =
          if chomps
            separator = others.find do |other|
              other.respond_to?(:to_str)
            end || $INPUT_RECORD_SEPARATOR

            proc do |line|
              yield(line.chomp(separator))
            end
          else
            ::Proc.new
          end

        super(*others, &block)
      end

      def lines(*args)
        hash, others = args.partition { |arg| arg.is_a?(::Hash) }
        chomps = hash[0] && hash[0][:chomp]

        unless block_given?
          lines = super(*others)

          if chomps
            separator = others.find do |other|
              other.respond_to?(:to_str)
            end || $INPUT_RECORD_SEPARATOR

            lines.each { |line| line.chomp!(separator) }
          end

          return lines
        end

        block =
          if chomps
            separator = others.find do |other|
              other.respond_to?(:to_str)
            end || $INPUT_RECORD_SEPARATOR

            proc do |line|
              yield(line.chomp(separator))
            end
          else
            ::Proc.new
          end

        super(*others, &block)
      end

      def match?(pattern, position = 0)
        !!(self[position..-1] =~ pattern)
      end

      def prepend(*others)
        return super if others.length == 1

        acc = '' << self
        others.reverse_each do |other|
          acc.prepend(other)
        end

        replace(acc)
      end

      def unpack1(*args)
        unpack(*args).first
      end
    end
  end
end
