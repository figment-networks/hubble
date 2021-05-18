module Near
  class Transaction < Common::Resource
    field :id
    field :time
    field :height
    field :hash
    field :sender
    field :receiver
    field :gas_burnt, type: :integer
    field :success
    collection :actions
  end
end
