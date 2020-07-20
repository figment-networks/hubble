class AddLatestLocalHeightToLivepeerChains < ActiveRecord::Migration[5.2]
  def change
    add_column :livepeer_chains, :latest_local_height, :integer, default: 0
  end
end
