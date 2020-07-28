class AddSlugToLivepeerChains < ActiveRecord::Migration[5.2]
  def change
    add_column :livepeer_chains, :slug, :string
    add_index :livepeer_chains, :slug
  end
end
