module Polyfill
  module V2_4
    module File
      module ClassMethods
        def empty?(file_name)
          zero?(file_name)
        end
      end
    end
  end
end
