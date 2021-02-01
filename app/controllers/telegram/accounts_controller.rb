module Telegram
  class AccountsController < Hubble::ApplicationController
    before_action :require_user
    layout 'account'

    def show
      @account = current_user.telegram_account || Telegram::Account.new

      respond_to do |format|
        format.html
        format.json
      end
    end

    def create
      @account = Telegram::Account.new(account_params)
      @account.user = current_user

      if @account.save
        redirect_to telegram_account_path
      else
        render :show
      end
    end

    def destroy
      @account = current_user.telegram_account
      @account&.destroy
      redirect_to telegram_account_path
    end

    private

    def account_params
      params.fetch(:telegram_account, {}).permit(:username)
    end
  end
end
