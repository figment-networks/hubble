class Livepeer::Delegator < ApplicationRecord
  belongs_to :chain

  def transcoder
    chain.transcoders.find_by(address: transcoder_address)
  end
end
