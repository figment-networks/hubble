class AddGraphqlApiUrlToMina < ActiveRecord::Migration[5.2]
  def change
    add_column :mina_chains, :graphql_api_url, :string
  end
end
