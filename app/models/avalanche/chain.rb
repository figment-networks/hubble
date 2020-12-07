class Avalanche::Chain < ApplicationRecord
  ASSET = 'avalanche'.freeze

  DEFAULT_TOKEN_DISPLAY = 'AVAX'.freeze
  DEFAULT_TOKEN_REMOTE = 'avax'.freeze
  DEFAULT_TOKEN_FACTOR = 18

  validates :name, presence: true
  validates :slug, format: { with: /\A[a-z0-9-]+\z/ }, uniqueness: true, presence: true
  validates :api_url, presence: true

  delegate :status, to: :client
  scope :primary, -> { find_by(primary: true) || order('created_at DESC').first }
  scope :enabled, -> { where(disabled: false) }

  def network_name
    'Avalanche'
  end

  def to_param
    slug
  end

  def enabled?
    !disabled
  end

  def token_map
    {
      DEFAULT_TOKEN_REMOTE => {
        display: DEFAULT_TOKEN_DISPLAY,
        factor: DEFAULT_TOKEN_FACTOR,
        primary: true
      }
    }.with_indifferent_access
  end

  def client
    @client ||= Avalanche::Client.new(api_url)
  end

  def status
    @client_status ||= client.status
  end
end
