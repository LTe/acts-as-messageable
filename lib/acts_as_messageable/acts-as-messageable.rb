module ActsAsMessageable
  module User

    def self.included(base)
      base.extend ClassMethods
      base.send :include, InstanceMethods
    end

    module ClassMethods
      def acts_as_messageable
      class_eval do
        has_many :messages, :as => :messageable, :class_name => "ActsAsMessageable::Message"
      end
    end
      
    end

    module InstanceMethods
      def messages(args = {})
        if args[:from] != nil && args[:to] == nil
          base.where(%(#{ActsAsMessageable::Message.table_name}.from = ?), args[:from].id)
        elsif args[:from] == nil && args[:to] != nil
          base.where(%(#{ActsAsMessageable::Message.table_name}.to = ?), args[:to].id)
        elsif args[:from] != nil && args[:to] != nil
          base.where(%(#{ActsAsMessageable::Message.table_name}.from = ? AND
                       #{ActsAsMessageable::Message.table_name}.to = ?),
                       args[:from].id, args[:to].id)
        else
          self.messages
        end
      end

      def send_message(to, topic, body)
        @message = ActsAsMessageable::Message.new
        @message.from, @message.to = self.id, to.id
        @message.topic, @message.body = topic, body

        self.messages << @message
        to.messages << @message

        self.save
        to.save
        @message.save
      end

    end

  end
end