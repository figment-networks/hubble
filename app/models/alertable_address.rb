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
    self.destroy unless self.alert_subscriptions.any?
  end

  def short_name(max_length = 16)
    address.truncate(max_length)
  end

  #temp placeholder, to be updated when events available in indexer
  def recent_events(klass, time_ago)
    [1, 2, 3, 4, 5]
  end
end
