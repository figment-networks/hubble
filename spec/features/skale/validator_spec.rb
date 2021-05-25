require 'features_helper'

describe 'skale validator details' do
  let(:chain) { create(:skale_chain) }
  let(:address) { '15' }

  before do
    current_time = Time.parse('2021-04-19 17:17:40')
    allow(Time).to receive(:now) { current_time }
  end

  it 'visiting validator details', :vcr do
    visit "/skale/chains/#{chain.slug}/validators/#{address}"
    expect(page).to have_content('STAKING BALANCE')
    expect(page).to have_content('Account')
    expect(page).to have_content('Currently active:')
    expect(page).to have_content('Figment')
    expect(page).to have_content('NEXT REWARD DATE')
  end
end
