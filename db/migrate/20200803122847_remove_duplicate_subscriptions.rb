class RemoveDuplicateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    User.with_subscriptions.find_each do |user|
      dupes = user.subscriptions.select(:baker_id).group(:baker_id).having("count(*) > 1").size

      dupes.each do |baker_id, count|
        user.subscriptions.where(baker_id: baker_id).order(created_at: :asc).limit(count - 1).destroy_all
      end
    end
  end
end

# fix for this legacy migration
class User < ApplicationRecord
  def self.with_subscriptions
    User.none
  end
end
