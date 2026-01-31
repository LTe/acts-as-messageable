require 'English'

module Polyfill
  module V2_4
    module StringIO
      module ClassMethods
        def foreach(name, *args)
          hash, others = args.partition { |arg| arg.is_a?(::Hash) }
          chomps = hash[0] && hash[0][:chomp]

          unless block_given?
            return super(name, *others) unless chomps

            separator = others.find do |other|
              other.respond_to?(:to_str)
            end || $INPUT_RECORD_SEPARATOR

            return ::Enumerator.new do |yielder|
              super(name, *others) do |line|
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

          super(name, *others, &block)
        end

        def readlines(file_name, *args)
          hash, others = args.partition { |arg| arg.is_a?(::Hash) }

          inputs = super(file_name, *others)

          if hash[0] && hash[0][:chomp]
            separator = others.find do |other|
              other.respond_to?(:to_str)
            end || $INPUT_RECORD_SEPARATOR

            inputs.each { |input| input.chomp!(separator) }
          end

          inputs
        end
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

      def gets(*args)
        hash, others = args.partition { |arg| arg.is_a?(::Hash) }

        input = super(*others)

        if !input.nil? && hash[0] && hash[0][:chomp]
          separator = others.find do |other|
            other.respond_to?(:to_str)
          end || $INPUT_RECORD_SEPARATOR

          input.chomp!(separator)
        end

        input
      end

      def lines(*args)
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

      def readline(*args)
        hash, others = args.partition { |arg| arg.is_a?(::Hash) }

        input = super(*others)

        if hash[0] && hash[0][:chomp]
          separator = others.find do |other|
            other.respond_to?(:to_str)
          end || $INPUT_RECORD_SEPARATOR

          input.chomp!(separator)
        end

        input
      end

      def readlines(*args)
        hash, others = args.partition { |arg| arg.is_a?(::Hash) }

        inputs = super(*others)

        if hash[0] && hash[0][:chomp]
          separator = others.find do |other|
            other.respond_to?(:to_str)
          end || $INPUT_RECORD_SEPARATOR

          inputs.each { |input| input.chomp!(separator) }
        end

        inputs
      end
    end
  end
end
