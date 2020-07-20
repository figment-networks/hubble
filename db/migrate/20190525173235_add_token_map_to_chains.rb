class AddTokenMapToChains < ActiveRecord::Migration[5.2]
  def change
    add_column :cosmos_chains, :token_map, :jsonb, default: {}
    add_column :terra_chains, :token_map, :jsonb, default: {}
    add_column :iris_chains, :token_map, :jsonb, default: {}

    def set_initial_token_map(chain)
      map = {}
      map[chain.remote_denom] = {
        factor: chain.token_factor,
        display: chain.token_denom,
        primary: true,
        report: true
      }
      chain.update_attributes token_map: map
    end

    Cosmos::Chain.find_each { |c| set_initial_token_map(c) }
    Iris::Chain.find_each { |c| set_initial_token_map(c) }
    Terra::Chain.find_each { |c| set_initial_token_map(c) }
  end
end
