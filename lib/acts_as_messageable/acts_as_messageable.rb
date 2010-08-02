module ActsAsMessageable
  module User

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_messageable
      class_eval do
        has_many :messages, :class_name => "ActsAsMessageable::Message"
      end
    end

    include ActsAsMessageable::User::InstanceMethods

    end

    module InstanceMethods

    end


  end
end