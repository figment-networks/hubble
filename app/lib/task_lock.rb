class TaskLock
  LOCK_EXPIRATION = 20.minutes.to_i

  attr_reader :name, :id, :connection_address

  def initialize(name, id, connection_address = ENV['MEM_CACHE_ADDRESS'])
    @name = name
    @id = id
    @connection_address = connection_address
  end

  def with_lock!(&block)
    client.lock do
      block.call
    end
  rescue Suo::LockClientError
    Rails.logger.info("Running #{resource} task without a lock because it was not possible to connect to Memcached")
    block.call
  end

  def self.with_lock!(name, id = nil, &block)
    TaskLock.new(name, id).with_lock!(&block)
  end

  private

  def client
    @client ||= Suo::Client::Memcached.new(resource, connection: connection_address, stale_lock_expiration: LOCK_EXPIRATION)
  end

  def resource
    [name, id].compact.join('-')
  end
end
