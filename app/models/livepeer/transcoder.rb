class Livepeer::Transcoder < ApplicationRecord
  belongs_to :chain

  scope :active, -> { where(active: true) }

  def to_param
    address
  end

  def name_or_address
    name || address.sub(/^0x/i, '').upcase
  end

  def events
    chain.events.where(transcoder_address: address)
  end
end
