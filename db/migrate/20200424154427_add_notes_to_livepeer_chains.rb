class AddNotesToLivepeerChains < ActiveRecord::Migration[5.2]
  def change
    add_column :livepeer_chains, :notes, :text
  end
end
