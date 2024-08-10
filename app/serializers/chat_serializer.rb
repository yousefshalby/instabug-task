class ChatSerializer < ActiveModel::Serializer
  attributes :application_id, :number, :messages_count, :created_at, :updated_at
end
