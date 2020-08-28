class AddTranscoderAddressToLivepeerDelegators < ActiveRecord::Migration[5.2]
  def change
    add_column :livepeer_delegators, :transcoder_address, :string
    add_index :livepeer_delegators, :transcoder_address
  end
end
