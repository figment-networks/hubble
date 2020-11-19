require 'rails_helper'

RSpec.describe Telegram::Message do
  it 'sends a message' do
    url = URI("https://api.telegram.org/bot#{Rails.application.secrets.telegram_api_key}/sendMessage?chat_id=asdf123&text=Testing+123&parse_mode=html")
    account = Telegram::Account.new(chat_id: 'asdf123')

    expect(Net::HTTP).to receive(:get_response).with(url).and_return(OpenStruct.new(body: 'success'))

    described_class.send(account: account, message: 'Testing 123')
  end

  describe '.tezos_alert_message' do
    let!(:user) { create(:user) }
    let!(:chain) { create(:tezos_chain) }
    let!(:baker_id) { 'tz2Q7Km98GPzV1JLNpkrQrSo5YUhPfDp6LmA' }
    let!(:alertable_address) { create(:alertable_address, chain: chain, address: baker_id) }
    let!(:subscription) { create(:alert_subscription, user: user, alertable: alertable_address, event_kinds: ['missed_bake'], wants_daily_digest: false, last_instant_at: 2.hours.ago) }
    let!(:events) { [Indexer::Event.new(id: 1, type: 'missed_bake', block_id: 123, sender_id: baker_id, sender_name: 'Figment')] }

    it 'generates the correct daily digest message', vcr: true do
      message = Telegram::Message.tezos_alert_message(subscription: subscription, events: events, type: :daily, date: Date.current)
      expect(message).to eq "<strong>Baker:</strong> #{baker_id}\n<strong>Chain:</strong> TezosChain\n<strong>Here is your daily digest for #{Date.current.strftime('%B %d, %Y')}. There was 1 new event today.</strong> \nBaker Figment missed a bake at block 123"
    end

    it 'generates the correct instant message', vcr: true do
      message = Telegram::Message.tezos_alert_message(subscription: subscription, events: events, type: :instant)
      expect(message).to eq "<strong>Baker:</strong> #{baker_id}\n<strong>Chain:</strong> TezosChain\n<strong>There has been 1 new event since we last notified you (on #{2.hours.ago.strftime('%Y-%m-%d %H:%M %Z')}):</strong> \nBaker Figment missed a bake at block 123"
    end

    it 'truncates really long messages' do
      alertable = OpenStruct.new(long_name: 'Figment', chain: chain)
      sub = OpenStruct.new(alertable: alertable, last_instant_at: 5.minutes.ago)
      message = Telegram::Message.tezos_alert_message(subscription: sub, events: events * 1000, type: :instant)
      expect(message.length).to eq 4000
    end
  end
end
