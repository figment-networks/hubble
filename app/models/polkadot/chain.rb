class Polkadot::Chain < ApplicationRecord
  ASSET = 'polkadot'.freeze

  # TODO: Replace KSM with DOTs when we switch from Kusama to Polkadot
  DEFAULT_TOKEN_DISPLAY = 'KSM'.freeze
  DEFAULT_TOKEN_REMOTE = 'ksm'.freeze
  DEFAULT_TOKEN_FACTOR = 12

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

  # TODO: Replace KSM with DOTs when we switch from Kusama to Polkadot
  def token_map
    {
      DEFAULT_TOKEN_REMOTE => {
        display: DEFAULT_TOKEN_DISPLAY,
        factor: 12,
        primary: true
      }
    }.with_indifferent_access
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
