module Polyfill
  module V2_5
    module Time
      module ClassMethods
        def at(*args)
          if args.size < 3 || args[2] == :microsecond || args[2] == :usec
            return super(*args.first(2))
          end

          seconds, partial_seconds, unit = args

          case unit
          when :millisecond
            super(seconds, partial_seconds * 1000)
          when :nanosecond, :nsec
            super(seconds, partial_seconds / 1000.0)
          else
            raise ArgumentError, "unexpected unit: #{unit}"
          end
        end
      end
    end
  end
end
