require 'indexer/resources/event'

class AlertSubscription < ApplicationRecord
  belongs_to :user
  belongs_to :alertable, polymorphic: true

  validate :subscribes_to_something?
  validate :appropriate_data?

  after_destroy :check_orphaned_alertable_address

  scope :by_network, ->(network) { where(network: network) }
  scope :eligible_for_instant_alert, -> { where('last_instant_at <= ?', ALERT_MINIMUM_TIMEOUT.ago) }
  scope :wants_daily_digest, -> { where(wants_daily_digest: true) }
  scope :daily_digest_due, lambda {
                             wants_daily_digest.where('last_daily_at <= ?', 1.day.ago.end_of_day)
                           }

  counter_culture :user,
                  column_name: proc { |model| model.network == 'Tezos' ? 'tezos_subscriptions_count' : nil },
                  column_names: { AlertSubscription.by_network('Tezos') => 'tezos_subscriptions_count' }

  def events
    alertable.validator_event_defs.find do |defn|
      defn['kind'].in?(event_kinds)
    end
  end

  def subscribes_to_kind?(kind)
    event_kinds.include? kind
  end

  def wants_event?(event)
    # are they subscribed to this type?
    ignored_event = !event_kinds.include?(event.kind_string)
    puts "\t\tSend #{event.kind_string} (wants #{event_kinds})" if ENV['DEBUG']

    # is it a voting power change, but not enough of a change?
    if !ignored_event && event.is_a?(Common::ValidatorEvents::VotingPowerChange)
      puts "\t\tSend voting power change? #{event.percentage_change.abs} >= #{data['percent_change']}" if ENV['DEBUG']
      good_enough = event.percentage_change.abs >= data['percent_change']
    elsif !ignored_event && event.is_a?(Indexer::Event) && event.type == 'balance_change'
      # Tezos Balance Change events return percentage change as a decimal (0.05 = 5%)
      puts "\t\tSend balance change? #{event.percentage_change.abs} >= #{data['percent_change']}" if ENV['DEBUG']
      good_enough = event.percentage_change.abs * 100 >= data['percent_change']
    else
      good_enough = true
    end

    !ignored_event && good_enough
  end

  def subscribes_to_something?
    if (event_kinds || []).empty? && !wants_daily_digest
      errors.add(:base, 'No alerts selected.')
      return false
    end
    return true
  end

  private

  def appropriate_data?
    return true unless event_kinds.include?('voting_power_change')

    if data['percent_change'].blank? || data['percent_change'] == 0.0
      errors.add(:base, 'That is not a valid percent of voting power change to notify on.')
    end
  end

  def check_orphaned_alertable_address
    if alertable_type == 'AlertableAddress'
      alertable.destroy_if_orphaned
    end
  end
end
