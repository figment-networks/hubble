class Oasis::Chain < ApplicationRecord
  include TokenMap

  ASSET = 'oasis'.freeze
  SUPPORTS_LEDGER = false

  DEFAULT_TOKEN_DISPLAY = 'ROSE'.freeze
  DEFAULT_TOKEN_REMOTE = 'noasis'.freeze
  DEFAULT_TOKEN_FACTOR = 9
  STALE_SYNC_TIME = 15

  has_many :alertable_addresses, as: :chain, dependent: :destroy
  has_many :alert_subscriptions, through: :alertable_addresses

  default_scope -> { order('position ASC') }
  scope :alive, -> { where.not(dead: true) }
  scope :primary, -> { find_by(primary: true) || order('created_at DESC').first }
  scope :enabled, -> { where(disabled: false) }

  validates :name, presence: true
  validates :slug, format: { with: /\A[a-z0-9-]+\z/ }, uniqueness: true, presence: true
  validates :api_url, presence: true

  def self.token_map
    {
      'amber' => {
        'noasis' => {
          'factor' => 9, 'display' => 'AMBER', 'primary' => true
        }
      },
      'default' => {
        'GAS' => {
          'factor' => 0, 'display' => 'GAS'
        },
        'noasis' => {
          'factor' => 9, 'display' => 'ROSE', 'primary' => true
        }
      }
    }
  end

  def to_param
    slug
  end

  def namespace
    self.class.name.deconstantize.constantize
  end

  def enabled?
    !disabled?
  end

  def network_name
    'Oasis'
  end

  def token_display
    DEFAULT_TOKEN_DISPLAY
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

  def primary_token
    DEFAULT_TOKEN_REMOTE
  end

  def primary_token_divisor
    10 ** DEFAULT_TOKEN_FACTOR
  end

  def client
    @client ||= Oasis::Client.new(api_url)
  end

  def last_sync_time
    @last_sync_time ||= client.status.last_indexed_time
  end

  def current_voting_power
    client.validators.sum(&:recent_total_shares)
  end

  def oasis_average_snapshots(kind, interval = 'hour', period = '48 hours', scope = nil)
    case kind
    when 'block-time'
      client.blocks_summary(interval, period)
    when 'voting-power'
      client.validators_summary(interval, period)
    when 'validator-uptime'
      client.validators_summary(interval, period, scope)
    end
  end

  def get_events_for_alert(subscription, seconds_ago, date = nil)
    client.get_events_for_alert(self, subscription, seconds_ago, date)
  end
end
