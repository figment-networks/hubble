class Tezos::Chain < ApplicationRecord
  ASSET = 'tezos'

  DEFAULT_TOKEN_DISPLAY = 'XTZ'
  DEFAULT_TOKEN_REMOTE = 'tezos'
  DEFAULT_TOKEN_FACTOR = 8

  after_save :ensure_single_primary_chain

  scope :disabled, -> { where( disabled: true ) }
  scope :enabled, -> { where( disabled: false ) }
  scope :primary, -> { find_by( primary: true ) || order('created_at DESC').first }

  validates :name, presence: true
  validates :slug, format: { with: /[a-z0-9-]+/ }, uniqueness: true, presence: true
  validates :indexer_api_base_url, presence: true

  def self.primary
    find_by(primary: true) || order(created_at: :desc).last
  end

  def enabled?
    !disabled?
  end

  def network_name
    "Tezos"
  end

  def to_param
    slug
  end

  private

  def ensure_single_primary_chain
    self.class.where.not(id: id).update_all(primary: false)
  end
end
