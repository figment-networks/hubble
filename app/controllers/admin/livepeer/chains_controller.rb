class Admin::Livepeer::ChainsController < Admin::BaseChainsController
  def create
    @chain = chain_class.new(new_chain_params)

    if @chain.save
      set_local_height
      ensure_single_primary_chain if @chain.primary?

      redirect_to admin_root_path, notice: 'Chain created successfully'
    else
      flash[:error] = @chain.errors.full_messages.join(', ')
      render :new
    end
  end

  def update
    if @chain.update(chain_params)
      ensure_single_primary_chain if @chain.primary?
      redirect_to admin_root_path, notice: 'Chain info has been updated!'
    else
      flash[:error] = @chain.errors.full_messages.join(', ')
      render :edit
    end
  end

  def show; end

  private

  def chain_class
    ::Livepeer::Chain
  end

  def new_chain_params
    params.require(:livepeer_chain).permit(:name, :slug, :subgraph_url, :primary, :testnet,
                                           :disabled)
  end

  def chain_params
    params.require(:livepeer_chain).permit(:disabled, :primary, :notes)
  end

  def set_local_height
    local_height = [0, params[:start_round].to_i - 1].max
    @chain.update_column(:latest_local_height, local_height)
  end
end
