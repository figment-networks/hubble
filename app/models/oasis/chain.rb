class Oasis::Chain < ApplicationRecord
  include TokenMap

  ASSET = 'oasis'.freeze
  SUPPORTS_LEDGER = false

  DEFAULT_TOKEN_DISPLAY = 'ROSE'.freeze
  DEFAULT_TOKEN_REMOTE = 'noasis'.freeze
  DEFAULT_TOKEN_FACTOR = 9

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

  def failing_sync?
    false
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

  def get_alertable_name(address)
    # to be updated to pull entity_name once that PR is merged
    validator = client.validator(address, 0)
    validator.entity_name.presence || validator.address
  end

  def get_events_for_alert(subscription, seconds_ago, date = nil)
    all_events = retrieve_events(subscription.alertable.address, seconds_ago)

    # filter out events prior to last alert time
    if !date
      filtered_events = all_events.select { |e| e.time > subscription.last_instant_at }
    else
      filtered_events = all_events.select do |e|
        e.time >= date.beginning_of_day && e.time <= date.end_of_day
      end
    end
  end

  def get_recent_events(address, klass, time_ago)
    all_events = retrieve_events(address, Time.now - time_ago)
    all_events.select { |e| e.time >= time_ago && klass == "Common::ValidatorEvents::#{e.kind.classify}".constantize }
  end

  private

  def retrieve_events(address, seconds_ago)
    # get events from twice the supplied timeframe to ensure all unsent events are picked up
    blocks_back = (seconds_ago * 2) / client.block_times(1000).avg
    start_block = (client.current_block.height - blocks_back).round.to_i

    client.validator_events(address, start_block)
  end
end
