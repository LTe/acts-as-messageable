module Polyfill
  module V2_4
    module Dir
      module ClassMethods
        def empty?(path_name)
          exist?(path_name) && (entries(path_name) - ['.', '..']).empty?
        end
      end
    end
  end
end
