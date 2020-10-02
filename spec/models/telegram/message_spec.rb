require 'rails_helper'

RSpec.describe Telegram::Message do
  it 'sends a message' do
    url = URI("https://api.telegram.org/bot#{Rails.application.secrets.telegram_api_key}/sendMessage?chat_id=asdf123&text=Testing+123")
    account = Telegram::Account.new(chat_id: 'asdf123')

    expect(Net::HTTP).to receive(:get_response).with(url).and_return(OpenStruct.new(body: 'success'))

    described_class.send(account: account, message: 'Testing 123')
  end
end
