class Prime::Terra::AccountDecorator < Prime::AccountDecorator
  def balance
    details.delegations.sum { |delegation| delegation[:amount] }
  end
end
