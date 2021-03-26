class Prime::Polkadot::AccountDecorator < Prime::AccountDecorator
  def balance
    details.free.to_f / (10 ** factor)
  end
end
