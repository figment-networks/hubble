class Polkadot::Chain < ApplicationRecord
  ASSET = 'polkadot'.freeze

  DEFAULT_TOKEN_DISPLAY = 'DOT'.freeze
  DEFAULT_TOKEN_REMOTE = 'dot'.freeze
  DEFAULT_TOKEN_FACTOR = 10

  validates :name, presence: true
  validates :slug, format: { with: /\A[a-z0-9-]+\z/ }, uniqueness: true, presence: true
  validates :api_url, presence: true

  delegate :status, to: :client
  scope :primary, -> { find_by(primary: true) || order('created_at DESC').first }
  scope :enabled, -> { where(disabled: false) }

  # TODO: validate - ensure there's only single primary chain, or fix in admin create controller

  def network_name
    'Polkadot'
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

  def primary_token
    DEFAULT_TOKEN_REMOTE
  end

  def primary_display
    DEFAULT_TOKEN_DISPLAY
  end

  def primary_token_divisor
    10 ** DEFAULT_TOKEN_FACTOR
  end

  def client
    @client ||= Polkadot::Client.new(api_url)
  end

  def status
    @client_status ||= client.status
  end

  def last_sync_time
    @last_sync_time ||= status.last_indexed_time
  end
end
