class Avalanche::AccountsController < Avalanche::BaseController
  include Pagy::Backend

  def show
    @account = client.account(params[:id])
    raise ActiveRecord::RecordNotFound unless @account

    validators = client.validators(reward_address: params[:id])
    delegations = client.delegations(reward_address: params[:id])
    @pagination_validators, @validators = pagy_array(validators, page_param: :validator_page)
    @pagination_delegations, @delegations = pagy_array(delegations, page_param: :delegator_page)
  end
end
