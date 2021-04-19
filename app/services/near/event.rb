module Near
  class Event < Common::Resource
    field :action
    field :block_height
    field :item_id
    collection :metadata
    field :created_at, type: :timestamp
  end
end
