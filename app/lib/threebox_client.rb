class ThreeboxClient
  BASE_URL = "https://ipfs.3box.io"

  def initialize(address)
    @address = address
  end

  def fetch_space(name)
    url = "#{BASE_URL}/space"
    params = { address: address, name: name }

    response = RestClient.get(url, params: params)

    Hashie::Mash::Rash.new(JSON.parse(response.body))
  rescue RestClient::NotFound
    Hashie::Mash::Rash.new({})
  end

  private

  attr_reader :address
end
