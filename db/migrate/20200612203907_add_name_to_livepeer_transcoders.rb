class AddNameToLivepeerTranscoders < ActiveRecord::Migration[5.2]
  def change
    add_column :livepeer_transcoders, :name, :string
  end
end
