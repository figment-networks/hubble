module Prime
  class TokenMetrics < Common::Resource
    field :price_usd
    field :one_day_price_change_percent_usd
    field :one_month_price_change_percent_usd
    field :one_year_price_change_percent_usd
    field :success, default: true

    alias success? success

    def initialize(attr)
      super(attr)
      if attr['success'].nil?
        @price_usd = attr['data']['market_data']['price_usd']
        @one_day_price_change_percent_usd = attr['data']['market_data']['percent_change_usd_last_24_hours']
        @one_month_price_change_percent_usd = attr['data']['roi_data']['percent_change_last_1_month']
        @one_year_price_change_percent_usd = attr['data']['roi_data']['percent_change_last_1_year']
      end
    end

    def self.failed
      new({ 'success' => false })
    end
  end
end
