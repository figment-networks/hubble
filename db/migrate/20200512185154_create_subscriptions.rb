class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.belongs_to :user, foreign_key: { on_delete: :cascade }
      t.string :baker_id

      t.timestamps
    end
  end
end
