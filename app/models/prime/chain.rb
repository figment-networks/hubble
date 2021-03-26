class Prime::Chain < ApplicationRecord
  validates :name, presence: true

  validates :type, presence: true
  validates :api_url, presence: true
  validates :reward_token_remote, presence: true
  validates :reward_token_display, presence: true
  validates :reward_token_factor, presence: true

  belongs_to :network, foreign_key: :prime_network_id, inverse_of: :chains

  after_save :ensure_single_primary_chain

  alias_attribute :primary_token_divisor, :reward_token_factor

  def to_param
    slug
  end

  def client
    raise NotImplementedError
  end

  def figment_validators
    raise NotImplementedError
  end

  private

  def ensure_single_primary_chain
    network.chains.where.not(id: id).update_all(primary: false) if primary?
  end
end
