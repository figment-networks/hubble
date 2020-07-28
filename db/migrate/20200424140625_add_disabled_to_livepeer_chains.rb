class AddDisabledToLivepeerChains < ActiveRecord::Migration[5.2]
  def change
    add_column :livepeer_chains, :disabled, :boolean, default: false
  end
end
