require "indexer/resources/baker"

class Subscription < ApplicationRecord
  belongs_to :user, counter_cache: true

  validates_uniqueness_of :baker_id, scope: :user_id

  def baker
    @baker ||= Indexer::Baker.retrieve(baker_id)
  end
end
