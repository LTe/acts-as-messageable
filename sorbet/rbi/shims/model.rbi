# typed: strict

module ActsAsMessageable
    module Model
      module ClassMethods
        mattr_accessor(:messages_class_name, :group_messages)
      end
    end
end
