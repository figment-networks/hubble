module TerraHelper
  SEARCH_INCLUDE_OPTIONS = [
    ['', 'All'],
    %w[sent Sent],
    %w[received Received]
  ].freeze

  def terra_tx_include_opts
    SEARCH_INCLUDE_OPTIONS
  end
end
