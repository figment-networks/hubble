class Iris::AccountSyncService < Cosmoslike::AccountSyncService
  private

  def get_delegator_accounts_for_validator(valoper)
    @chain.syncer.get_validator_delegations(valoper).map do |delegation|
      @chain.accounts.find_or_create_by!(address: delegation['delegator_addr'])
    end +
      @chain.syncer.get_validator_unbonding_delegations(valoper).map do |delegation|
        @chain.accounts.find_or_create_by!(address: delegation['delegator_addr'])
      end
  end
end
