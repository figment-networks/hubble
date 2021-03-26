class Polkadot::Chain < ApplicationRecord
  include TokenMap

  ASSET = 'polkadot'.freeze

  DEFAULT_TOKEN_DISPLAY = 'DOT'.freeze
  DEFAULT_TOKEN_REMOTE = 'dot'.freeze
  DEFAULT_TOKEN_FACTOR = 10
  STALE_SYNC_TIME = 15
  DEFAULT_VALIDATOR_EVENTS = [{ 'kind' => 'voting_power_change', 'height' => 0 },
                              { 'kind' => 'active_set_inclusion', 'height' => 0 },
                              { 'kind' => 'reward_cut_change', 'height' => 0 },
                              { 'kind' => 'delegation_change', 'height' => 0 },
                              { 'kind' => 'n_of_m', 'n' => 50, 'm' => 1000, 'height' => 0 },
                              { 'kind' => 'n_consecutive', 'n' => 150, 'height' => 0 }].freeze

  has_many :alertable_addresses, as: :chain, dependent: :destroy
  has_many :alert_subscriptions, through: :alertable_addresses

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

  def primary_display
    DEFAULT_TOKEN_DISPLAY
  end

  def primary_token_divisor
    10 ** DEFAULT_TOKEN_FACTOR
  end

  def failing_sync?
    last_sync_time < STALE_SYNC_TIME.minutes.ago
  end

  def has_dashboard?
    true
  end

  def alertable_type
    'validator'
  end

  def validator_event_defs
    DEFAULT_VALIDATOR_EVENTS
  end

  def get_events_for_alert(subscription, seconds_ago, date = nil)
    client.get_events_for_alert(self, subscription, seconds_ago, date)
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
