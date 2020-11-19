class BackfillSubscriptionNetworks < ActiveRecord::Migration[5.2]
  def change
    AlertSubscription.find_each do |sub|
      if sub.alertable && sub.alertable.respond_to?(:chain_type) && sub.alertable.chain_type.present?
        # Need to use update_columns so that CounterCulture doesn't try to update counts before column is added
        sub.update_columns(network: sub.alertable.chain_type.split('::').first)
      end
    end
  end
end
