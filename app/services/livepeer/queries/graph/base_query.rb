class Livepeer::Queries::Graph::BaseQuery
  LIMIT = nil
  BATCH_SIZE = 1000
  REQUEST_DELAY = 1.second

  def initialize(chain, round_data = nil)
    @chain = chain
    @round_data = Hashie::Mash::Rash.new(round_data)
  end

  def call
    objects = []
    offset = 0

    loop do
      sleep self.class::REQUEST_DELAY
      log("Fetching #{resource_name} (offset: #{offset})")

      query = build_query(batch_size, offset)
      results = client.execute(query).data[resource]

      raise 'Invalid query' if results.nil?

      objects.concat(results)

      if objects.count == self.class::LIMIT
        return objects
      elsif results.count < batch_size
        return objects
      else
        offset += batch_size
      end
    end
  ensure
    count = objects.count
    log("Fetched #{count} #{resource_name.pluralize(count)}")
  end

  private

  attr_reader :chain
  attr_reader :round_data

  def resource
    self.class.name.demodulize.delete_suffix('Query').camelize(:lower)
  end

  def resource_name
    resource.to_s.underscore.humanize.downcase
  end

  def batch_size
    [self.class::BATCH_SIZE, self.class::LIMIT].compact.min
  end

  def log(message)
    if round_data.present?
      logger.info("Round #{round_data.id}") { message }
    else
      logger.info(message)
    end
  end

  def logger
    @logger ||= Logger.new($stdout)
  end

  def client
    @client ||= GQLi::Client.new(chain.subgraph_url, validate_query: false)
  end
end
