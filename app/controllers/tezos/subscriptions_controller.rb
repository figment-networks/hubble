module Tezos
  class SubscriptionsController < ApplicationController
    before_action :require_user

    def create
      current_user.subscriptions.create(baker_id: params[:baker_id])

      if current_user.has_telegram_account?
        redirect_to tezos_baker_path(params[:baker_id])
      else
        redirect_to telegram_account_path, flash: { success: "Please connect your Telegram account so we can send you notifications." }
      end
    end

    def destroy
      @subscription = current_user.subscriptions.find(params[:id])
      @subscription.destroy
      redirect_to tezos_baker_path(@subscription.baker_id)
    end
  end
end
