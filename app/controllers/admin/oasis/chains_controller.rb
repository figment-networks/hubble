class Admin::Oasis::ChainsController < Admin::BaseChainsController
  def create
    @chain = chain_class.create(chain_params)
    @chain.update(
      token_map: {
        "#{@chain.class::DEFAULT_TOKEN_REMOTE}": {
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
      redirect_to admin_root_path, notice: 'Chain created successfully'
    else
      flash[:error] = @chain.errors.full_messages.join(', ')
      render :new
    end
  end

  def show
    @status = @chain.client.status
  end

  def update
    @chain = chain_class.find_by slug: params[:id]
    raise ActionController::NotFound unless @chain

    if params.has_key?(:oasis_chain)
      updates = params.require(:oasis_chain).permit(
        %i[
          primary disabled dead api_url
        ],
        validator_event_defs: %i[unique_id kind n m height]
      )
    else
      updates = {}
    end

    if updates.has_key?(:validator_event_defs)
      # sanitize event defs to an array
      updates[:validator_event_defs] = updates[:validator_event_defs].values

      # sanitize n, m, and height fields to integers
      params_defns = updates[:validator_event_defs].index_by { |defn| defn['unique_id'] }
      existing_defns = @chain.validator_event_defs.index_by { |defn| defn['unique_id'] }
      new_defns = []

      params_defns.keys.each do |defn_id|
        new_defn = if existing_defns.keys.include?(defn_id)
                     existing_defns[defn_id].merge params_defns[defn_id]
                   else
                     params_defns[defn_id]
                   end
        new_defn['n'] = new_defn['n'].to_i if new_defn.has_key?('n')
        new_defn['m'] = new_defn['m'].to_i if new_defn.has_key?('m')
        new_defn['height'] = new_defn.has_key?('height') || 1

        new_defns << new_defn
      end

      updates[:validator_event_defs] = new_defns
    end

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

    Rails.logger.info("UPDATES: #{updates}")
    @chain.update updates

    if !@chain.valid?
      flash[:error] = @chain.full_messages.join(', ')
      render :edit
    else
      # make sure only 1 chain is primary
      if @chain.primary?
        ensure_single_primary_chain
      end
      redirect_to admin_root_path, notice: 'Chain info has been updated!'
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
