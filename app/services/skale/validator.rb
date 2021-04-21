module Skale
  class Validator < Common::Resource
    field :id, type: :integer
    field :name
    field :fee_rate, type: :integer
    field :accept_new_requests
    field :authorized
    field :active_nodes, type: :integer
    field :staked, type: :integer

    def display_name
      @name
    end

    def fee_rate
      @fee_rate / 10
    end

    def accepting?
      accept_new_requests == true
    end

    def active?
      @authorized ? true : false
    end
  end
end
