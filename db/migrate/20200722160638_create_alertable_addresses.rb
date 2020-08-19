class CreateAlertableAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :alertable_addresses do |t|
      t.references :chain, polymorphic: true
      t.string :address
    end
  end
end
