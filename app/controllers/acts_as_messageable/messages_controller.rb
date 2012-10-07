module ActsAsMessageable
  class MessagesController < ::ApplicationController
    respond_to :html, :json

    def index
      @messages = current_user.received_messages
      respond_with(@messages)
    end

    def outbox
      @messages = current_user.sent_messages
      respond_with(@messages)
    end

    def trash
      @messages = current_user.deleted_messages
      respond_with(@messages)
    end

    def show
      @message = current_user.messages.find(params[:id])
      @message.read if @message.to == current_user

      respond_with(@message)
    end

    def destroy
      @message = current_user.messages.find(params[:id])
      current_user.delete_message(@message)

      respond_with(@message)
    end

    def new
      @message = current_user.messages_class_name.new
    end

    def create
      @to = User.find_by_id(params[:user_id])
      @message = current_user.send_message(@to, params[:message])

      respond_with(@message)
    end

    def reply
      @message = current_user.messages.find(params[:id])

      if request.post?
        @message.reply(params[:message])
      else
        current_user.messages_class_name.new
      end

      render :show if @reply_message && @reply_message.valid?
    end
  end
end