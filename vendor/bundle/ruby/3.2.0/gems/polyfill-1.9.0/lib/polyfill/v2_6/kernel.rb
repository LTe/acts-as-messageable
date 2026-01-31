module Polyfill
  module V2_6
    module Kernel
      using Polyfill(Kernel: %w[#yield_self], version: '2.5')

      def Complex(*args, exception: true) # rubocop:disable Naming/MethodName
        super(*args) if exception

        x, y = *args
        if !x.nil? && !x.is_a?(::String) && !x.is_a?(::Numeric) && !y.nil? && y.is_a?(::Numeric)
          raise ::TypeError, 'not a real'
        end

        begin
          super(*args)
        rescue ::ArgumentError, ::TypeError
          nil
        end
      end

      def Float(arg, exception: true) # rubocop:disable Naming/MethodName
        super(arg) if exception

        begin
          super(arg)
        rescue ::ArgumentError, ::TypeError
          nil
        end
      end

      def Integer(arg, exception: true) # rubocop:disable Naming/MethodName
        super(arg) if exception

        begin
          super(arg)
        rescue ::ArgumentError, ::TypeError, ::FloatDomainError
          nil
        end
      end

      def Rational(*args, exception: true) # rubocop:disable Naming/MethodName
        super(*args) if exception

        begin
          super(*args)
        rescue ::ArgumentError, ::TypeError
          nil
        end
      end

      def then
        return yield_self unless block_given?

        yield_self(&::Proc.new)
      end
    end
  end
end
