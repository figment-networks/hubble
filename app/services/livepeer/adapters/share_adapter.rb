class Livepeer::Adapters::ShareAdapter < Livepeer::Adapters::BaseAdapter
  attribute :delegator_address
  attribute :fees
  attribute :reward_tokens

  def delegator_address
    data.delegator.id
  end

  def fees
    convert_eth_amount(data.fees)
  end

  def reward_tokens
    convert_lpt_amount(data.reward_tokens)
  end
end
