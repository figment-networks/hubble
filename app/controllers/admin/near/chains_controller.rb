class Admin::Near::ChainsController < Admin::BaseChainsController
  def show
    @status = @chain.status
    # TODO: rescure a common Client error
  rescue Near::Client::Error => e
    flash[:error] = "Cant fetch service status: #{e}"
  end

  def update
    if @chain.update(chain_updates)
      flash[:success] = 'Chain info has been updated!'
      redirect_to admin_near_chain_path(@chain)
    else
      flash[:error] = 'Unable to update chain info'
      render :edit
    end
  end

  private

  def chain_class
    ::Near::Chain
  end

  def init_new_chain
    @chain = namespace.new(request.get? ? {} : chain_params)
  end

  # TODO: Should be refactored (and replaced in other chain controllers)
  def chain_updates
    updates = params.key?(:near_chain) ? chain_params : {}

    if params.has_key?(:new_token)
      updates[:token_map] = @chain.token_map.merge(
        "#{params[:new_token][:remote]}": {
          display: params[:new_token][:display],
          factor: params[:new_token][:factor].to_i
        }
      )
      if params[:new_token][:primary]
        updates[:token_map] = updates[:token_map].map { |k, v| v['primary'] = false; [k, v] }.to_h
        updates[:token_map][:"#{params[:new_token][:remote]}"]['primary'] = true
      end
    end

    if params.has_key?(:remove_token)
      updates[:token_map] = @chain.token_map.without(params[:remove_token])
    end

    updates
  end
end
