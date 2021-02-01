class AddPrimeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :prime, :boolean, default: false
  end
end
