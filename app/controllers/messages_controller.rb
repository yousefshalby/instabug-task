class MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :set_application_and_chat

  def create
    if @chat && @application
      chat_id = @chat.id
      application_token = @application.token
      CreateMessageJob.perform_now(chat_id, application_token, message_params[:body])
      next_message_number = @chat.messages.maximum(:number).to_i + 1
      render json: { message_number: next_message_number, status: "Message is being processed and will appear soon." }, status: :accepted
    else
      render json: { error: "Application or chat not found" }, status: :not_found
    end
  end


  def search
    if @chat && @application
      @messages = Message.search_messages(params[:chat_id], params[:query]).records
      render json: @messages, each_serializer: MessageSerializer
    else
      render json: { error: "Application or chat not found" }, status: :not_found
    end
  end

  private

  def set_application_and_chat
    @application = Application.find_by(token: params[:application_id])
    unless @application
      render json: { error: "Application not found" }, status: :not_found and return
    end

    @chat = @application.chats.find_by(number: params[:chat_id])
    unless @chat
      render json: { error: "Chat not found" }, status: :not_found and return
    end
  end

  def message_params
    params.require(:message).permit(:body)
  end
end
