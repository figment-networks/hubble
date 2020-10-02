class Cosmos::AccountsController < Cosmoslike::AccountsController
  # Cosmoslike::AccountsController temporarily overrideen due to
  # delegations indexing issue - this method should just be
  # deleted once that problem is corrected.
  def show
    respond_to do |format|
      format.html do
        @found_account = @chain.accounts.find_by(address: params[:id])
        page_title @chain.network_name, @chain.name, params[:id]
        meta_description "Balance, and Pending Rewards for #{params[:id]}#{" (owner of #{@found_account.validator.long_name})" if @found_account.try(:validator)}"
      end
      format.json do
        syncer = @chain.syncer(3000)

        if params.has_key?(:dashboard_info)
          account_info = {
            balances: syncer.get_account_balances(params[:id]),
            rewards: syncer.get_account_rewards(params[:id])
          }
        else
          account_info = syncer.get_account_info(params[:id])

          if account_info && params[:validator]
            account_info['rewards_for_validator'] = syncer.get_account_rewards(params[:id], params[:validator])
          end
        end

        render json: account_info
      end
    end
  end
end
