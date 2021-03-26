class Prime::Oasis::AccountDecorator < Prime::AccountDecorator
  def balance
    details.total_balance.to_f / (10 ** factor)
  end
end
