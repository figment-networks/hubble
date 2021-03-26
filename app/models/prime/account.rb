class Prime::Account < ApplicationRecord
  validates :address, presence: true
  validates :address,
            uniqueness: { scope: %i[user_id prime_network_id],
                          message: 'This address is already in your portfolio.' }

  belongs_to :user
  belongs_to :network, foreign_key: :prime_network_id, inverse_of: :accounts

  scope :on_enabled_networks, -> { joins(:network).merge(Prime::Network.enabled) }
  scope :for_user, ->(user_id) { where(user_id: user_id) }
  scope :for_network, ->(network_id) { where(prime_network_id: network_id) }

  def details
    raise NotImplementedError
  end

  def rewards
    raise NotImplementedError
  end
end
