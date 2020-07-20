class AddDescriptionToLivepeerTranscoders < ActiveRecord::Migration[5.2]
  def change
    add_column :livepeer_transcoders, :description, :string
  end
end
