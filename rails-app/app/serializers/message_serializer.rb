class MessageSerializer < ActiveModel::Serializer
  attributes :number, :body, :chat_id, :created_at, :updated_at
end
