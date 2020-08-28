class AddTransactionHashToLivepeerEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :livepeer_events, :transaction_hash, :string
    add_index :livepeer_events, :transaction_hash
  end
end
