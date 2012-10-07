require "active_support/core_ext/hash/slice"

module ActionDispatch::Routing
  class Mapper
    def messages_resource(*args)
      options   = args.extract_options!

      options[:controller]  ||= "acts_as_messageable/messages"
      options[:resource]    ||= :messages

      resources options[:resource], :controller => options[:controller] do
        member do
          get   :reply
          post  :reply
        end
        collection do
          get :outbox
          get :trash
        end
      end
    end
  end
end

