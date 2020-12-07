class Cosmoslike::AccountsController < Cosmoslike::BaseController
  def show
    respond_to do |format|
      format.html do
        @found_account = @chain.accounts.find_by(address: params[:id])
        @account = @chain.namespace::AccountDecorator.new(@chain, params[:id])
        raise ActiveRecord::RecordNotFound if !@account.exists?

        page_title @chain.network_name, @chain.name, params[:id]
        meta_description "Delegations, Recent Delegation Transactions, Balance, and Pending Rewards for #{params[:id]}#{" (owner of #{@found_account.validator.long_name})" if @found_account.try(:validator)}"
      end
      format.json do
        syncer = @chain.syncer(3000)

        if params.has_key?(:dashboard_info)
          account_info = {
            balances: syncer.get_account_balances(params[:id]),
            delegations: syncer.get_account_delegations(params[:id]),
            rewards: syncer.get_account_rewards(params[:id])
          }
        else
          account_info = syncer.get_account_info(params[:id])

          if account_info && params[:validator]
            account_info['rewards_for_validator'] = syncer.get_account_rewards(params[:id],
                                                                               params[:validator])
          end
        end

        render json: account_info
      end
    end
  end
end
