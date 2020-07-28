class Livepeer::Adapters::PoolAdapter < Livepeer::Adapters::BaseAdapter
  attribute :transcoder_address
  attribute :total_stake
  attribute :fees
  attribute :reward_tokens

  has_many :shares

  def transcoder_address
    data.delegate.id
  end

  def total_stake
    convert_lpt_amount(data.total_stake)
  end

  def fees
    convert_eth_amount(data.fees)
  end

  def reward_tokens
    convert_lpt_amount(data.reward_tokens)
  end
end
