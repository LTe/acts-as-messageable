module Polyfill
  module V2_5
    module Dir
      module ClassMethods
        def children(dirname, encoding: Encoding.find('filesystem'))
          entries(dirname, encoding: encoding) - %w[. ..]
        end

        def each_child(dirname, encoding: Encoding.find('filesystem'))
          unless block_given?
            return ::Enumerator.new do |yielder|
              (entries(dirname, encoding: encoding) - %w[. ..]).each do |filename|
                yielder.yield(filename)
              end
            end
          end

          (entries(dirname, encoding: encoding) - %w[. ..]).each do |filename|
            yield(filename)
          end

          nil
        end
      end
    end
  end
end
