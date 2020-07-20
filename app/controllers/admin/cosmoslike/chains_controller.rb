class Admin::Cosmoslike::ChainsController < Admin::BaseController

  def new
    @chain = @namespace::Chain.new
  end

  def create
    @chain = @namespace::Chain.create(
      params.require(:"#{@namespace.name.downcase}_chain").permit( %i{
        name slug sdk_version disabled
        primary testnet
        rpc_host lcd_host rpc_path lcd_path rpc_port lcd_port
        use_ssl_for_rpc use_ssl_for_lcd
      } )
    )

    @chain.update_attributes(
      token_map: {
        :"#{@chain.class::DEFAULT_TOKEN_REMOTE}" => {
          display: @chain.class::DEFAULT_TOKEN_DISPLAY,
          factor: @chain.class::DEFAULT_TOKEN_FACTOR,
          primary: true
        }
      }
    )

    if !params[:start_height].blank?
      target_height = params[:start_height].to_i - 1
      @chain.update_attributes(
        latest_local_height: target_height,
        history_height: target_height,
        validator_event_defs: @chain.validator_event_defs.map { |defn| defn['height'] = target_height; defn },
        cutoff_at: Time.now
      )
    end

    if @chain.persisted? && @chain.valid?
      if @chain.primary?
        @namespace::Chain.where.not( id: @chain.id ).update_all primary: false
      end
      redirect_to namespaced_path( admin: true )
    else
      flash[:error] = @chain.errors.full_messages.join(', ')
      redirect_to admin_root_path
    end
  end

  def show
    @chain = @namespace::Chain.find_by slug: params[:id]
    raise ActionController::NotFound unless @chain
  end

  def update
    @chain = @namespace::Chain.find_by slug: params[:id]
    raise ActionController::NotFound unless @chain

    if params.has_key?(:"#{@namespace.name.downcase}_chain")
      updates = params.require(:"#{@namespace.name.downcase}_chain").permit(
        %i{
          sdk_version notes primary disabled dead
          rpc_host lcd_host rpc_path lcd_path rpc_port lcd_port
          use_ssl_for_rpc use_ssl_for_lcd
          validator_event_defs
        },
        validator_event_defs: %i{ unique_id kind n m height },
        twitter_events_config: @chain.class::TWITTER_CONFIG_FIELDS
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
        new_defn['height'] = new_defn.has_key?('height') ? new_defn['height'].to_i : @chain.latest_local_height

        new_defns << new_defn
      end

      updates[:validator_event_defs] = new_defns
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
      redirect_to namespaced_path( admin: true )
    else
      # make sure only 1 chain is primary
      if @chain.primary?
        @namespace::Chain.where.not( id: @chain.id ).update_all primary: false
      end

      flash[:notice] = "Chain info updated."
      redirect_to namespaced_path( admin: true )
    end
  end

  def move_up
    @chain = @namespace::Chain.find_by slug: params[:id]
    raise ActionController::NotFound unless @chain
    @chain.move_higher
    redirect_to admin_root_path
  end

  def move_down
    @chain = @namespace::Chain.find_by slug: params[:id]
    raise ActionController::NotFound unless @chain
    @chain.move_lower
    redirect_to admin_root_path
  end

  def destroy
    @chain = @namespace::Chain.find_by slug: params[:id]
    raise ActionController::NotFound unless @chain
    @chain.destroy
    flash[:notice] = 'Chain deleted. All data purged.'
    redirect_to admin_root_path
  end
end
