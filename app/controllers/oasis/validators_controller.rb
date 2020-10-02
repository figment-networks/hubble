class Oasis::ValidatorsController < Oasis::BaseController
  before_action :set_behind_chain_alert

  def show
    @validator = @chain.client.validator(params[:id], 50)

    @alertable_address = AlertableAddress.find_by(chain: @chain, address: @validator.address)
    @events = @chain.client.validator_events(@validator.address)

    page_title @chain.network_name, @chain.name, @validator.address, 'Voting Power and Event History'
    meta_description 'Voting History -- All changes, Uptime history -- Last 48 hours, Governance Proposals, Activity and Event History'
  rescue Common::IndexerClient::Error => error
    @validator = Oasis::Validator.failed(params[:id])
    @error = error
  end
end
