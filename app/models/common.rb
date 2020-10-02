module Common
  def self.table_name_prefix
    'common_'
  end

  def self.remotely_indexed?(chain)
    if chain.try(:api_url) || chain.try(:indexer_api_base_url)
      true
    else
      false
    end
  end
end
