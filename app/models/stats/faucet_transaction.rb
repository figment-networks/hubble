class Stats::FaucetTransaction < ApplicationRecord
  belongs_to :faucetlike, polymorphic: true
  belongs_to :user, required: false

  validate :valid_destination_address

  default_scope { order('created_at DESC') }

  scope :incomplete, -> { where(completed_at: nil, result_data: nil) }
  scope :errored, -> { where(completed_at: nil, error: true) }
  scope :successful, -> { where.not(completed_at: nil).where.not(error: true) }

  def completed?
    !completed_at.nil?
  end

  def failed?
    !completed? && error
  end

  def height
    result_data['height'].to_i
  end

  private

  def valid_destination_address
    if address.nil?
      errors.add(:address, 'must be specified')
    else
      if address !~ /^#{faucetlike.chain.prefixes[:account_address]}.+/
        errors.add(:address, 'must be in an appropriate bech32 format')
      end
    end
  end
end
