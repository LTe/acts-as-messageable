module ActsAsMessageable
  module Model

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_messageable(options = {})
      class_eval do
        has_many  :received_messages, 
                  :as => :received_messageable, 
                  :class_name => "ActsAsMessageable::Message", 
                  :dependent => :nullify
        has_many  :sent_messages, 
                  :as => :sent_messageable,
                  :class_name => "ActsAsMessageable::Message", 
                  :dependent => :nullify
      end
      
      table_name = %q{set_table_name "#{options[:table_name] || "messages"}"}
      ActsAsMessageable::Message.class_eval(table_name)

      include ActsAsMessageable::Model::InstanceMethods
    end

    end

    module InstanceMethods
      def messages(options = {}, &block)
        result = ActsAsMessageable::Message.connected_with(self, false)

        result.relation_context = self

        result.each do |r|
          r.context = self
        end

        result
      end

      def send_message(to, topic, body)
        @message = ActsAsMessageable::Message.create!(:topic => topic, :body => body)

        self.sent_messages << @message
        to.received_messages << @message
      end

      def delete_message(message)
        current_user = self

        if message.received_messageable == current_user
          message.update_attributes!(:recipient_delete => true)
        elsif message.sent_messageable == current_user
          message.update_attributes!(:sender_delete => true)
        end
      end

    end

  end
end
