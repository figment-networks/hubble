class AddLatestLocalHeightToChains < ActiveRecord::Migration[5.2]
  def change
    add_column :cosmos_chains, :latest_local_height, :integer, default: 0
    add_column :terra_chains, :latest_local_height, :integer, default: 0
    add_column :iris_chains, :latest_local_height, :integer, default: 0

    [ Cosmos::Chain, Terra::Chain, Iris::Chain ].each do |chain_type|
      chain_type.find_each do |chain|
        chain.update_attributes( latest_local_height: chain.blocks.first.try(:height) || 0 )
      end
    end
  end
end

# this migration throws a puzzling error and needs to be re-run with `rake db:migrate`
