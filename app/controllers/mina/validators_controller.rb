class Mina::ValidatorsController < Mina::BaseController
  before_action :fetch_validator_details

  def show
    @validator = @details.validator
    @account = @details.account
    @delegations = @details.delegations

    @blocks = client.blocks
    @transactions = client.transactions(account: @account.public_key)
    @staking_pool = client.validators.sum(&:stake)
    @stats_daily = Mina::ValidatorStatsDecorator.new(@chain, @details.stats_daily)
    @stats_hourly = Mina::ValidatorStatsDecorator.new(@chain, @details.stats_hourly)

    page_title 'Validator'
    meta_description "Validator #{@validator.public_key}"
  end

  private

  def fetch_validator_details
    @details = client.validator(params[:id])
  end
end
