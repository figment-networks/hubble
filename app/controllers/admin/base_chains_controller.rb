class Admin::BaseChainsController < Admin::BaseController
  before_action :require_chain, except: %i[new create]

  def new
    @chain = chain_class.new
  end

  def create
    @chain = chain_class.new(chain_params)
    if @chain.save
      redirect_to admin_root_path, notice: 'Chain created successfully'
    else
      flash[:error] = @chain.errors.full_messages.join(', ')
      render :new
    end
  end

  def update
    if @chain.update(chain_params)
      redirect_to admin_root_path, notice: 'Chain info has been updated!'
    else
      flash[:error] = @chain.errors.full_messages.join(', ')
      render :edit
    end
  end

  def move_up
    @chain.move_higher
    redirect_to admin_root_path
  end

  def move_down
    @chain.move_lower
    redirect_to admin_root_path
  end

  def destroy
    if @chain.destroy
      redirect_to admin_root_path, notice: 'Chain has been deleted!'
    else
      redirect_to :back, notice: 'Unable to delete the chain'
    end
  end

  def ensure_single_primary_chain
    chain_class.where.not(id: @chain.id).update_all(primary: false)
  end

  def chain_class
    raise NotImplementedError
  end

  def require_chain
    @chain = chain_class.find_by!(slug: params[:id])
  end

  def chain_params
    raise NotImplementedError
  end
end
