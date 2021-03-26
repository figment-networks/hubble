class Prime::Accounts::Polkadot < Prime::Account
  def details
    @details ||= network.primary.client.account_details(address)
  end

  def rewards
    @rewards ||= network.primary.client.prime_rewards(self)
  end
end
