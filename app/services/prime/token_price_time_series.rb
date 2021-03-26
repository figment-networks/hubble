module Prime
  class TokenPriceTimeSeries < Common::Resource
    field :tohlcv_values
    field :success, default: true

    alias success? success

    def initialize(attr)
      super(attr)
      @tohlcv_values = attr['data']['values'] if attr['success'].nil?
    end

    def self.failed
      new({ 'success' => false })
    end
  end
end
