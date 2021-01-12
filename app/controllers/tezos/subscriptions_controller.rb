module Tezos
  class SubscriptionsController < ::Util::SubscriptionsController
    private

    layout 'application'

    def set_chain_and_validator
      @namespace = params[:network].titleize.constantize
      @chain = Tezos::Chain.primary

      @alertable = AlertableAddress.find_or_initialize_by(chain: @chain, address: params[:baker_id])
      @validator = Indexer::Baker.retrieve(params[:baker_id])

      raise ActiveRecord::RecordNotFound unless @validator
    end

    def alertable_type_name
      'Baker'
    end

    def after_create_path
      tezos_baker_subscriptions_path
    end

    def digest_disabled
      true
    end
  end
end
