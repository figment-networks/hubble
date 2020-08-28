class Oasis::ValidatorsController < Oasis::BaseController
  before_action :set_behind_chain_alert

  def show
    @validator = @chain.client.validator(CGI.unescape(params[:id]), 50)
    raise ActiveRecord::RecordNotFound unless @validator
    @alertable_address = AlertableAddress.find_by(chain: @chain, address: @validator.address)

    page_title @chain.network_name, @chain.name, @validator.address, 'Voting Power and Event History'
    meta_description "Voting History -- All changes, Uptime history -- Last 48 hours, Governance Proposals, Activity and Event History"
  end
end
