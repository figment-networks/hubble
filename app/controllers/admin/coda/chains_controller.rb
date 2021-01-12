class Admin::Coda::ChainsController < Admin::BaseChainsController
  def show
    @status = @chain.status
  rescue Coda::Client::Error => error
    flash[:error] = "Cant fetch service status: #{error}"
  end

  def update
    if @chain.update(chain_updates)
      flash[:success] = 'Chain info has been updated!'
      redirect_to admin_coda_chain_path(@chain)
    else
      flash[:error] = 'Unable to update chain info'
      render :edit
    end
  end

  private

  def chain_class
    ::Coda::Chain
  end

  def init_new_chain
    @chain = namespace.new(request.get? ? {} : chain_params)
  end

  # TODO: Should be refactored (and replaced in other chain controllers)
  def chain_updates
    updates = params.key?(:coda_chain) ? chain_params : {}

    updates
  end
end
