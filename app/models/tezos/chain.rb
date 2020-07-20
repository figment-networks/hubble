class Tezos::Chain < ApplicationRecord
  ASSET = 'tezos'

  after_save :ensure_single_primary_chain

  scope :disabled, -> { where( disabled: true ) }
  scope :enabled, -> { where( disabled: false ) }

  def self.primary
    find_by(primary: true) || order(created_at: :desc).last
  end

  def enabled?
    !disabled?
  end

  def network_name
    "Tezos"
  end

  def to_param
    slug
  end

  private

  def ensure_single_primary_chain
    self.class.where.not(id: id).update_all(primary: false)
  end
end
