module Polkadot
  class Status < Common::Resource
    # Indexer returns ~25 attributes that are not necessary yet
    ATTRIBUTES = %i[
      last_indexed_height
      app_version
      last_indexed_time
      go_version
      success
    ].freeze
    attr_accessor(*ATTRIBUTES)

    def initialize(attributes = {})
      attributes['success'] = true if attributes['success'].nil?
      super(attributes.slice(*ATTRIBUTES.map(&:to_s)))
      @last_indexed_time = Time.zone.parse(last_indexed_time) if last_indexed_time
    end

    alias last_block_height last_indexed_height
    alias last_block_time last_indexed_time
    alias success? success

    def self.failed
      new({ 'success' => false })
    end
  end
end
