class Livepeer::DelegatorList < ApplicationRecord
  RECORDS_LIMIT = 10

  belongs_to :user
  belongs_to :chain

  scope :for, ->(chain) { where(chain: chain) }

  before_validation :normalize_addresses

  validates :name, presence: true, uniqueness: { scope: [:user, :chain] }
  validates :addresses, length: { in: 1..50 }

  validate :addresses_format
  validate :addresses_duplicates
  validate :delegator_lists_per_user, on: :create

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
end
