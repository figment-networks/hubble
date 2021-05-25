class Prime::Accounts::Cosmos < Prime::Account
  def details
    @details ||= ::Cosmos::AccountDecorator.new(::Cosmos::Chain.find_by(slug: network.primary.slug), address)
  end

  def rewards
    @rewards ||= network.primary.client.prime_rewards(self)
  end
end
