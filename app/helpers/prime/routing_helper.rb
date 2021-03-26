module Prime::RoutingHelper
  def hubble_network_linker(network)
    send("#{network.name}_chain_path", "#{network.name.capitalize}::Chain".constantize.primary)
  end

  def hubble_account_linker(account)
    send("#{account.network.name}_chain_account_path", "#{account.network.name.capitalize}::Chain".constantize.primary, account.address)
  end

  def hubble_validator_linker(network, address)
    send("#{network.downcase}_chain_validator_path", "#{network.capitalize}::Chain".constantize.primary, address)
  end

  def hubble_validator_linker_title(validator)
    "#{validator.network_name} (#{validator.address.truncate(18)})"
  end
end
