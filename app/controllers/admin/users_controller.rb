class Admin::UsersController < Admin::BaseController
  def index
    @users = User.all
  end

  def show
    @user = User.find params[:id]
  end

  def destroy
    @user = User.find params[:id]
    name = @user.name
    @user.update_attributes deleted: true
    flash[:notice] = "#{name} has been deleted."
    redirect_to admin_users_path
  end

  def masq
    session[:masq] = User::MASQ_TIMEOUT.from_now.to_i
    session[:uid] = User.find(params[:id]).id
    redirect_to root_path
  end
end
