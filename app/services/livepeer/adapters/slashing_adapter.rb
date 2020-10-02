class Livepeer::Adapters::SlashingAdapter < Livepeer::Adapters::EventAdapter
  attribute :penalty

  def penalty
    convert_lpt_amount(data.penalty)
  end
end
