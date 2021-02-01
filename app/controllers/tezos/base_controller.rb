module Tezos
  class BaseController < Hubble::ApplicationController
    before_action :set_chain

    private

    def set_chain
      @chain = Tezos::Chain.primary
    end
  end
end
