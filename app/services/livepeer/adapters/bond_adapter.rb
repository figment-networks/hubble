class Livepeer::Adapters::BondAdapter < Livepeer::Adapters::BaseAdapter
  attribute :transaction_hash
  attribute :delegator_address
  attribute :transcoder_address
  attribute :old_transcoder_address
  attribute :amount
  attribute :initialized_at

  def delegator_address
    data.delegator.id
  end

  def transcoder_address
    data.new_delegate.id
  end

  def old_transcoder_address
    data.old_delegate&.id
  end

  def amount
    convert_lpt_amount(data.additional_amount)
  end

  def initialized_at
    convert_timestamp(data.timestamp)
  end
end
