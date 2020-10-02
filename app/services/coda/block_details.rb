module Coda
  class BlockDetails < Resource
    field :block,   type: Coda::Block
    field :creator, type: Coda::Account

    collection :snark_jobs,   type: Coda::SnarkJob
    collection :transactions, type: Coda::Transaction
  end
end
