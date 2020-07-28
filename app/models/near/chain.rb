class Near::Chain < ApplicationRecord
  ASSET = "near"

  DEFAULT_TOKEN_DISPLAY = "NEAR"
  DEFAULT_TOKEN_REMOTE  = "near"
  DEFAULT_TOKEN_FACTOR  = 9

  validates :name,    presence: true
  validates :slug,    format: { with: /[a-z0-9-]+/ }, uniqueness: { case_sensitive: false }
  validates :api_url, presence: true

  scope :enabled, -> { where(disabled: false) }

  delegate :status, to: :client

  def network_name
    "NEAR"
  end

  def to_param
    slug
  end

  def enabled?
    !disabled
  end

  def out_of_sync?
    status&.stale?
  end

  def client
    @client ||= Near::Client.new(api_url)
  end
end
