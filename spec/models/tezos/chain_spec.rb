require 'rails_helper'

RSpec.describe Tezos::Chain do
  it 'refreshes latest_event_height by calling reload' do
    chain = create(:tezos_chain, primary: true, latest_event_height: 1)
    expect(chain.latest_event_height).to eq 1

    chain2 = Tezos::Chain.primary
    expect(chain2.latest_event_height).to eq 1

    chain.update(latest_event_height: 100)

    expect(chain2.latest_event_height).to eq 1

    chain2.reload
    expect(chain2.latest_event_height).to eq 100
  end
end
