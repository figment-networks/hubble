module Polkadot
  class Status < Common::Resource
    # Indexer returns ~25 attributes that are not necessary yet
    ATTRIBUTES = [
      :last_indexed_height,
      :app_version,
      :last_indexed_time,
      :go_version,
      :success
    ]
    attr_accessor *ATTRIBUTES

    def initialize(attrs = {})
      attrs['success'] = true if attrs['success'].nil?
      super(attrs.slice(*ATTRIBUTES.map(&:to_s)))
      @last_indexed_time = Time.zone.parse(last_indexed_time) if last_indexed_time
    end

    alias_method :last_block_height, :last_indexed_height
    alias_method :last_block_time, :last_indexed_time
    alias_method :success?, :success

    def self.failed
      new({'success' => false})
    end
  end
end
