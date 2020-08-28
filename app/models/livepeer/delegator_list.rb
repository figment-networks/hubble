class Livepeer::DelegatorList < ApplicationRecord
  RECORDS_LIMIT = 10

  belongs_to :user
  belongs_to :chain

  has_many :alert_subscriptions, as: :alertable, dependent: :delete_all

  scope :for, ->(chain) { where(chain: chain) }

  before_validation :normalize_addresses

  validates :name, presence: true, uniqueness: { scope: [:user, :chain] }
  validates :addresses, length: { in: 1..50 }

  validate :addresses_format
  validate :addresses_duplicates
  validate :delegator_lists_per_user, on: :create

  alias_attribute :long_name, :name

  def short_name(max_length = nil)
    max_length ? name.truncate(max_length) : name
  end

  def events
    chain.events.where(transcoder_address: transcoder_addresses)
  end

  def recent_events(type, since)
    events.where(type: type).where('timestamp >= ?', since)
  end

  private

  def normalize_addresses
    addresses.each { |a| normalize_address(a) }
  end

  def normalize_address(value)
    value.downcase!
    value.prepend('0x') unless value.starts_with?('0x')
  end

  def addresses_format
    unless addresses.all? { |a| a =~ /\A0x[0-9a-f]{40}\z/ }
      errors.add(:addresses, :invalid)
    end
  end

  def addresses_duplicates
    if addresses.count != addresses.uniq.count
      errors.add(:addresses, :contain_duplicates)
    end
  end

  def delegator_lists_per_user
    if user.livepeer_delegator_lists.for(chain).count + 1 > RECORDS_LIMIT
      errors.add(:base, :too_many_delegator_lists, limit: RECORDS_LIMIT)
    end
  end

  def transcoder_addresses
    chain.delegators.where(address: addresses).pluck(:transcoder_address)
  end
end
