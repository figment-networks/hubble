require 'indexer/resources/baker'
require 'indexer/resources/event'
require 'indexer/resources/block'

class Tezos::Chain < ApplicationRecord
  ASSET = 'tezos'.freeze

  DEFAULT_TOKEN_DISPLAY = 'XTZ'.freeze
  DEFAULT_TOKEN_REMOTE = 'tezos'.freeze
  DEFAULT_TOKEN_FACTOR = 8

  after_save :ensure_single_primary_chain

  has_many :alertable_addresses, as: :chain, dependent: :destroy
  has_many :alert_subscriptions, through: :alertable_addresses

  scope :disabled, -> { where(disabled: true) }
  scope :enabled, -> { where(disabled: false) }
  scope :primary, -> { find_by(primary: true) || order('created_at DESC').first }

  validates :name, presence: true
  validates :slug, format: { with: /[a-z0-9-]+/ }, uniqueness: true, presence: true
  validates :indexer_api_base_url, presence: true

  def self.primary
    find_by(primary: true) || order(created_at: :desc).last
  end

  def enabled?
    !disabled?
  end

  def namespace
    self.class.name.deconstantize.constantize
  end

  def network_name
    'Tezos'
  end

  def has_dashboard?
    true
  end

  def to_param
    slug
  end

  def validator_event_defs
    [
      { kind: 'missed_bake', filter: true },
      { kind: 'missed_endorsement', filter: true },
      { kind: 'steal', filter: true },
      { kind: 'double_bake', filter: true },
      { kind: 'double_endorsement', filter: true },
      { kind: 'baker_activated', filter: true },
      { kind: 'baker_deactivated', filter: true },
      { kind: 'balance_change', filter: true }
    ].map(&:with_indifferent_access)
  end

  def event_kinds
    validator_event_defs.map { |e| e[:kind] }
  end

  def event_filters
    validator_event_defs.select { |e| e[:filter] }.map { |e| e[:kind] }
  end

  def failing_sync?
    false
  end

  def get_events_for_alert(subscription, _seconds_ago, date = nil)
    events = if date.present?
               Indexer::Event.list(after_timestamp: date.yesterday.end_of_day.to_i, before_timestamp: date.tomorrow.beginning_of_day.to_i, paginate: false)[:events]
             else
               Indexer::Event.list(after_timestamp: subscription.last_instant_at.to_i, paginate: false)[:events]
             end

    # Filter events relevant to the subscription
    events.select { |e| e.subscription_address == subscription.alertable.address }
  end

  def get_alertable_name(address)
    baker = Indexer::Baker.retrieve(address)
    baker.long_name
  end

  def alertable_type
    'baker'
  end

  def alert_delivery_method
    :telegram
  end

  def last_sync_time
    @last_sync_time ||= Indexer::Block.retrieve('latest').timestamp
  end

  private

  def ensure_single_primary_chain
    self.class.where.not(id: id).update_all(primary: false)
  end
end
