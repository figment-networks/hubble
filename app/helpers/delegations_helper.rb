module DelegationsHelper
  def disabled_delegations?(chain)
    disabled = %w[cosmoshub-4 columbus-4]
    disabled.include?(chain.ext_id)
  end
end
