require 'money-tree'

class Admin::Cosmoslike::FaucetsController < Admin::BaseController
  before_action :ensure_chain

  def create
    words = params[:words].blank? ? BipMnemonic.to_mnemonic(bits: 256) : params[:words]
    seed = BipMnemonic.to_seed( mnemonic: words )
    master = MoneyTree::Master.new( seed_hex: seed )
    priv = master.private_key.to_hex

    faucet = @chain.create_faucet( private_key: priv )

    flash[:notice] = "Faucet created. You may fund #{faucet.address}"
    if params[:words].blank?
      flash[:warning] = "<strong>Seed Phrase - WRITE THIS DOWN</strong><br/><span class='technical'>#{words}</span>"
    end

    redirect_to admin_cosmos_chain_path(@chain)
  end

  def update
    @chain.faucet.assign_attributes params.require(:cosmos_faucet).permit(%i{ disbursement_amount fee_amount denom })
    if params.has_key?(:disable)
      @chain.faucet.assign_attributes disabled: true
    end
    if params.has_key?(:enable)
      @chain.faucet.assign_attributes disabled: false
    end

    if params.has_key?(:destroy)
      @chain.faucet.destroy
    else
      @chain.faucet.save
    end

    redirect_to admin_cosmos_chain_path(@chain)
  end

  def destroy
    @chain.faucet.try(:destroy)
    redirect_to admin_cosmos_chain_path(@chain)
  end

  def show
    @transactions = @chain.faucet.transactions
  end

  protected

  def ensure_chain
    raise ArgumentError.new( "Implement #ensure_chain for #{self.class.name}" )
  end
end
