class CreateTelegramAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :telegram_accounts do |t|
      t.string :username
      t.string :chat_id

      t.timestamps
    end
    add_index :telegram_accounts, :username
    add_reference :telegram_accounts, :user, foreign_key: true, index: {unique: true}, on_delete: :cascade
  end
end
