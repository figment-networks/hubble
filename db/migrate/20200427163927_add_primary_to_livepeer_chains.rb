class AddPrimaryToLivepeerChains < ActiveRecord::Migration[5.2]
  def change
    add_column :livepeer_chains, :primary, :boolean, default: false
  end
end
