class Admin::Oasis::ChainsController < Admin::BaseChainsController

  def create
    @chain = chain_class.create(chain_params)
    @chain.update_attributes(
      token_map: {
        :"#{@chain.class::DEFAULT_TOKEN_REMOTE}" => {
          display: @chain.class::DEFAULT_TOKEN_DISPLAY,
          factor: @chain.class::DEFAULT_TOKEN_FACTOR,
          primary: true
        }
      }
    )

    if @chain.persisted? && @chain.valid?
      if @chain.primary?
        ensure_single_primary_chain
      end
      redirect_to admin_root_path, notice: "Chain created successfully"
    else
      flash[:error] = @chain.errors.full_messages.join(', ')
      render :new
    end
  end

  def update
    @chain = chain_class.find_by slug: params[:id]
    raise ActionController::NotFound unless @chain

    if params.has_key?(:oasis_chain)
      updates = params.require(:oasis_chain).permit(
        %i{
          primary disabled dead api_url
        }
      )
    else
      updates = {}
    end

    if params.has_key?(:new_token)
      updates[:token_map] = @chain.token_map.merge(
        :"#{params[:new_token][:remote]}" => {
          display: params[:new_token][:display],
          factor: params[:new_token][:factor].to_i
        }
      )
      if params[:new_token][:primary]
        updates[:token_map] = updates[:token_map].map { |k,v| v['primary'] = false; [k,v] }.to_h
        updates[:token_map][:"#{params[:new_token][:remote]}"]['primary'] = true
      end
    end
    if params.has_key?(:remove_token)
      updates[:token_map] = @chain.token_map.without(params[:remove_token])
    end

    Rails.logger.info("UPDATES: #{updates}")
    @chain.update_attributes updates

    if !@chain.valid?
      flash[:error] = @chain.full_messages.join(', ')
      render :edit
    else
      # make sure only 1 chain is primary
      if @chain.primary?
        ensure_single_primary_chain 
      end
      redirect_to admin_root_path, notice: "Chain info has been updated!"
    end
  end

  private 

  def chain_class
    ::Oasis::Chain
  end

  def chain_params
    params.require(:oasis_chain).permit(:name, :slug, :api_url, :primary, :testnet, :disabled)
  end
end
