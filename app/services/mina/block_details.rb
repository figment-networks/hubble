module Mina
  class BlockDetails < Common::Resource
    field :block, type: Mina::Block
    field :creator, type: Mina::Account

    collection :snark_jobs, type: Mina::SnarkJob
    collection :transactions, type: Mina::Transaction
  end
end
