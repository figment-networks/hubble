class Prime::ValidatorDecorator < SimpleDelegator
  include ActionView::Helpers::NumberHelper

  # TO DO: Need reward rate from indexer
  def reward_rate_as_percentage
    'N/A'
  end
end
