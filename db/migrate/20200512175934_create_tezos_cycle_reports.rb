class CreateTezosCycleReports < ActiveRecord::Migration[5.2]
  def change
    create_table :tezos_cycle_reports do |t|
      t.integer :cycle_number

      t.timestamps
    end
  end
end
