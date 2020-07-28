module Near
  class Block < Common::Resource
    attr_accessor :id,
                  :app_version,
                  :height,
                  :time,
                  :producer,
                  :hash,
                  :prev_hash,
                  :epoch,
                  :gas_price,
                  :gas_allowed,
                  :gas_used,
                  :rent_paid,
                  :validator_reward,
                  :total_supply,
                  :signature,
                  :chunks_count,
                  :transactions_count,
                  :created_at,
                  :updated_at

    def initialize(attrs = {})
      super(attrs)

      @time       = Time.zone.parse(time)
      @created_at = Time.zone.parse(created_at)
      @updated_at = Time.zone.parse(updated_at)
    end
  end
end
