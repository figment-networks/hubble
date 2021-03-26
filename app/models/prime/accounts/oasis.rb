class Prime::Accounts::Oasis < Prime::Account
  def details
    @details ||= network.primary.client.account(address, retrieve_delegations: false)
  end

  def rewards
    @rewards ||= network.primary.client.prime_rewards(self)
  end
end
