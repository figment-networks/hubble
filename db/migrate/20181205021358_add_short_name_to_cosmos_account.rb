class AddShortNameToCosmosAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :cosmos_accounts, :short_name, :string, default: ""
  end
end
