class CreateMessageJob < ApplicationJob
  queue_as :default

  def perform(chat_id, application_token, content)
    chat = Chat.find_by(id: chat_id, application: Application.find_by(token: application_token))

    if chat
      chat.add_message(content)
    else
      Rails.logger.error "Chat with ID #{chat_id} and application_token #{application_token} not found"
    end
  end
end
