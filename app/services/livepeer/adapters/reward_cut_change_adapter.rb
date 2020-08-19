class Livepeer::Adapters::RewardCutChangeAdapter < Livepeer::Adapters::BaseAdapter
  attribute :transaction_hash
  attribute :transcoder_address
  attribute :reward_cut
  attribute :timestamp

  def transcoder_address
    data.delegate.id
  end

  def reward_cut
    convert_percentage(data.reward_cut).to_f
  end

  def timestamp
    convert_timestamp(data.timestamp)
  end
end
