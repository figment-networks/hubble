class Livepeer::ChainSyncService
  def initialize(chain)
    @chain = chain
  end

  def call
    Livepeer::Chain.transaction do
      synchronize(:rounds)
      synchronize(:transcoders, delete: true)
      synchronize(:delegators, delete: true)

      update_local_height
      update_synchronization_time
    end
  end

  private

  attr_reader :chain

  def synchronize(resource, delete: false)
    objects = fetch_objects(resource)

    objects.each do |data|
      synchronize_object(resource, data)
    end

    delete_remaining_records(resource, objects) if delete
  end

  def fetch_objects(resource)
    query_class = Livepeer::Factories::GraphQueryFactory.new(resource).call
    query_class.new(chain).call
  end

  def synchronize_object(resource, data)
    service_class = Livepeer::Factories::SyncServiceFactory.new(resource).call
    service_class.new(chain, data).call
  end

  def delete_remaining_records(resource, objects)
    Livepeer::DeleteRemainingRecordsService.new(chain, resource, objects).call
  end

  def update_local_height
    local_height = chain.rounds.maximum(:number) || 0
    chain.update_column(:latest_local_height, local_height)
  end

  def update_synchronization_time
    chain.touch(:last_sync_time)
  end

  def client
    @client ||= GQLi::Client.new(chain.subgraph_url, validate_query: false)
  end
end
