class AddPositionToLivepeerChains < ActiveRecord::Migration[5.2]
  def change
    add_column :livepeer_chains, :position, :integer
  end
end
