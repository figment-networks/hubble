module Mina
  class SnarkJob < Common::Resource
    field :prover
    field :fee, type: :integer
    field :works_count
  end
end
