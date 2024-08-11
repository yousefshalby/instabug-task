class Message < ApplicationRecord
  include Elasticsearch::Model
  # include Elasticsearch::Model::Callbacks

  belongs_to :chat, counter_cache: true
  validates :number, presence: true, uniqueness: { scope: :chat_id }
  after_initialize :set_message_number, if: :new_record?

  settings do
    mappings dynamic: false do
      indexes :body, type: :text, analyzer: "english"
      indexes :chat_id, type: :integer
    end
  end

  def as_indexed_json(options = {})
    as_json(only: [ :body, :chat_id ])
  end

  def self.search_messages(chat_id, query)
    self.search({
      query: {
        bool: {
          must: [
            { match: { chat_id: chat_id } },
            { match_phrase_prefix: { body: query } }
          ]
        }
      }
    })
  end

  private

  def set_message_number
    max_number = chat.messages.maximum(:number) || 0
    self.number = max_number + 1
  end
end
