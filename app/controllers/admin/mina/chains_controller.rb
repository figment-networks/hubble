class Admin::Mina::ChainsController < Admin::BaseChainsController
  def show
    @status = @chain.status
  rescue Mina::Client::Error => error
    flash[:error] = "Cant fetch service status: #{error}"
  end

  def update
    if @chain.update(chain_updates)
      flash[:success] = 'Chain info has been updated!'
      redirect_to admin_mina_chain_path(@chain)
    else
      flash[:error] = 'Unable to update chain info'
      render :edit
    end
  end

  private

  def chain_class
    ::Mina::Chain
  end

  def init_new_chain
    @chain = namespace.new(request.get? ? {} : chain_params)
  end

  # TODO: Should be refactored (and replaced in other chain controllers)
  def chain_updates
    updates = params.key?(:mina_chain) ? chain_params : {}

    updates
  end

  def chain_params
    params.require(chain_class.model_name.param_key).permit(:name, :slug, :api_url, :graphql_api_url, :testnet, :disabled, :primary)
  end
end
