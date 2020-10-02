class AlertableAddress < ApplicationRecord
  belongs_to :chain, polymorphic: true
  has_many :alert_subscriptions, as: :alertable, dependent: :delete_all

  alias_attribute :name_and_owner, :address

  def to_param
    address
  end

  def validator_event_defs
    chain.validator_event_defs
  end

  def destroy_if_orphaned
    destroy unless alert_subscriptions.any?
  end

  def long_name
    chain.get_alertable_name(address)
  end

  def short_name(max_length = 16)
    long_name.truncate(max_length)
  end

  # temp placeholder, to be updated when events available in indexer
  def recent_events(_klass, _time_ago)
    [1, 2, 3, 4, 5]
  end
end
