class Application < ApplicationRecord
    has_many :chats, dependent: :destroy
    validates :name, presence: true
    validates :token, presence: true, uniqueness: true

    after_initialize :generate_token, if: :new_record?

    private

    def generate_token
      self.token = SecureRandom.hex(10)
    end
end
