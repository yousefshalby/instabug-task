class Chat < ApplicationRecord
  belongs_to :application, counter_cache: true
  has_many :messages, dependent: :destroy

  validates :number, presence: true, uniqueness: { scope: :application_id }
  after_initialize :set_chat_number, if: :new_record?

  def add_message(content)
    transaction do
      self.lock!
      messages.create!(body: content)
    end
  end

  private

  def set_chat_number
    max_number = application.chats.maximum(:number) || 0
    self.number = max_number + 1
  end



  def cached_messages
    Rails.cache.fetch([ self, "messages" ]) { messages.to_a }
  end
end
