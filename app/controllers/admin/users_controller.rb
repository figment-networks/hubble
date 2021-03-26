class Admin::UsersController < Admin::BaseController
  def index
    if params[:prime_only]
      @users = User.with_prime_access
    else
      @users = User.all
    end
  end

  def show
    @user = User.find params[:id]
  end

  def destroy
    @user = User.find params[:id]
    name = @user.name
    @user.update deleted: true
    flash[:notice] = "#{name} has been deleted."
    redirect_to admin_users_path
  end

  def masq
    session[:masq] = User::MASQ_TIMEOUT.from_now.to_i
    session[:uid] = User.find(params[:id]).id
    redirect_to root_path
  end

  def toggle_prime
    user = User.find_by(id: params[:id])
    user.toggle! :prime
    redirect_to admin_users_path
  end
end
