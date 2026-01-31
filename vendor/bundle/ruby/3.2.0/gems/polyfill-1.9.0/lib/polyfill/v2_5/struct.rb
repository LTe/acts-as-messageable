module Polyfill
  module V2_5
    module Struct
      module ClassMethods
        def new(*args, keyword_init: false)
          obj = super(*args)

          if keyword_init
            attrs = args
            attrs.shift if attrs.first.class != Symbol

            ignore_warnings do
              obj.send(:define_method, :initialize) do |**kwargs|
                invalid_args = kwargs.reject { |k, _| attrs.include?(k) }.keys
                unless invalid_args.empty?
                  raise ArgumentError, "unknown keywords: #{invalid_args.join(', ')}"
                end

                super(*kwargs.values_at(*attrs))
              end
            end
          end

          obj
        end
      end
    end
  end
end
