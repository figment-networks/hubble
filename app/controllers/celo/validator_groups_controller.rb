class Celo::ValidatorGroupsController < Celo::BaseController
  def show
    @validator_group = client.validator_group(params[:id])
    @validators = client.validators(params[:id])
    raise ActiveRecord::RecordNotFound unless @validator_group
  end
end
