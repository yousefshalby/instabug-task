class ChatsController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :set_application

    def index
      render json: @application.chats, each_serializer: ChatSerializer
    end

    def create
      chat = @application.chats.new
      if chat.save
        render json: chat, status: :created, serializer: ChatSerializer
      else
        render json: chat.errors, status: :unprocessable_entity
      end
    end

    def show
      @chat = Chat.includes(:messages).find(params[:id])
      render json: @chat, serializer: ChatSerializer
    end

    private

    def set_application
      @application = Application.find_by(token: params[:application_id])
    end
end
