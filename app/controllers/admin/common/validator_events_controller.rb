class Admin::Common::ValidatorEventsController < Admin::BaseController
  def index
    @chain = @namespace::Chain.find_by slug: params[:chain_id]
    raise ActionController::NotFound unless @chain
  end

  def destroy
    Common::ValidatorEvent.find(params[:id]).destroy
    redirect_to request.referrer
  end
end
