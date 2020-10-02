class Telegram::Account < ApplicationRecord
  belongs_to :user, inverse_of: :telegram_account

  # https://telegram.org/faq#q-what-can-i-use-as-my-username
  validates :username, presence: true,
                       length: { minimum: 5, allow_blank: true },
                       format: { with: /\A[a-zA-Z\d_]{5,}\z/, allow_blank: true },
                       uniqueness: { case_sensitive: false }

  def self.by_username(username)
    find_by('LOWER(username) = ?', username.downcase)
  end
end
