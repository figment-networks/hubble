class Livepeer::Adapters::RoundAdapter < Livepeer::Adapters::BaseAdapter
  attribute :initialized_at
  attribute :mintable_tokens

  has_many :pools
  has_many :stakes
  has_many :bonds
  has_many :unbonds
  has_many :rebonds

  def initialized_at
    convert_timestamp(data.timestamp)
  end

  def mintable_tokens
    convert_lpt_amount(data.mintable_tokens)
  end
end
