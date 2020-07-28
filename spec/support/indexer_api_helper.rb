module IndexerApiHelper
  def stub_endpoint(path, params, fixture_name, status = 200)
    url = "#{indexer_endpoint}#{path}"
    if params.any?
      url += "?" + params.to_a.map { |k,v| "#{k}=#{v}" }.join("&")
    end

    stub_request(:get, url).
      to_return(
        status:  status,
        body:    file_fixture("#{indexer_name}/#{fixture_name}.json").read,
        headers: { "Content-Type": "application/json" }
      )
  end
end
