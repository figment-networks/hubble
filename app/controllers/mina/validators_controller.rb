class Mina::ValidatorsController < Mina::BaseController
  before_action :fetch_validator_details

  def show
    @validator    = @details.validator
    @account      = @details.account
    @delegations  = @details.delegations

    @blocks       = client.blocks
    @transactions = client.transactions(account: @account.public_key)
    @staking_pool = client.validators.sum(&:account_balance)
    @stats        = Mina::ValidatorStatsDecorator.new(@chain, @details.stats)

    page_title 'Validator'
    meta_description "Validator #{@validator.account}"
  end

  private

  def fetch_validator_details
    @details = client.validator(params[:id])
  end
end
