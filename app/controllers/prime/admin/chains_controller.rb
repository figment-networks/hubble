class Prime::Admin::ChainsController < Prime::Admin::BaseController
  before_action :require_network, only: %i[new create]
  before_action :require_chain, except: %i[new create]

  def new
    @chain = Prime::Chain.new
  end

  def create
    @chain = Prime::Chain.new(create_chain_params)

    if @chain.save
      redirect_to prime_admin_root_path, notice: 'Chain created successfully'
    else
      flash[:error] = @chain.errors.full_messages.join(', ')
      render :new
    end
  end

  def update
    if @chain.update(update_chain_params)
      redirect_to prime_admin_root_path, notice: 'Chain info has been updated!'
    else
      flash[:error] = @chain.errors.full_messages.join(', ')
      render :edit
    end
  end

  def destroy
    if @chain.destroy
      redirect_to prime_admin_root_path, notice: 'Chain has been deleted!'
    else
      redirect_to :back, notice: 'Unable to delete the chain'
    end
  end

  def show; end

  private

  def require_network
    @network = Prime::Network.find_by!(name: params[:network_id])
  end

  def require_chain
    @chain = Prime::Chain.find_by!(slug: params[:id])
  end

  def chain_class
    "prime_chains_#{@chain.network.name}".to_sym
  end

  def update_chain_params
    if params[chain_class][:figment_validator_addresses]
      address_array = params[chain_class][:figment_validator_addresses].split(/\s*,\s*/)
      params[chain_class][:figment_validator_addresses] = address_array
    end

    params.require(chain_class).permit(:name,
                                       :slug,
                                       :prime_network_id,
                                       :type,
                                       :api_url,
                                       :active,
                                       :primary,
                                       :reward_token_remote,
                                       :reward_token_display,
                                       :reward_token_factor,
                                       :genesis_block_time,
                                       :genesis_block_height,
                                       :final_block_time,
                                       :final_block_height,
                                       figment_validator_addresses: [])
  end

  def create_chain_params
    params[:prime_chain][:type] = "Prime::Chains::#{@network.name.capitalize}"

    params.require(:prime_chain).permit(:name,
                                        :slug,
                                        :prime_network_id,
                                        :type,
                                        :api_url,
                                        :active,
                                        :primary,
                                        :reward_token_remote,
                                        :reward_token_display,
                                        :reward_token_factor,
                                        :genesis_block_time,
                                        :genesis_block_height,
                                        :final_block_time,
                                        :final_block_height,
                                        figment_validator_addresses: [])
  end
end
