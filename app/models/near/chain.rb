class Near::Chain < ApplicationRecord
  ASSET = 'near'.freeze

  DEFAULT_TOKEN_DISPLAY = 'NEAR'.freeze
  DEFAULT_TOKEN_REMOTE  = 'near'.freeze
  DEFAULT_TOKEN_FACTOR  = 9

  validates :name, presence: true
  validates :slug, format: { with: /\A[a-z0-9-]+\z/ }, uniqueness: { case_sensitive: false }
  validates :api_url, presence: true

  scope :enabled, -> { where(disabled: false) }
  scope :primary, -> { find_by(primary: true) || order('created_at DESC').first }

  delegate :status, to: :client

  def network_name
    'NEAR'
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
