class AddWebsiteUrlToLivepeerTranscoders < ActiveRecord::Migration[5.2]
  def change
    add_column :livepeer_transcoders, :website_url, :string
  end
end
