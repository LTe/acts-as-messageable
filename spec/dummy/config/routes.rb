Dummy::Application.routes.draw do
  messages_resource

  scope "user" do
    messages_resource
  end
end
