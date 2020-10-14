require 'features_helper'

describe 'polkadot account details' do
  let(:chain) { create(:polkadot_chain) }
  let(:address) { '1341kcAXqyA5ZJHBdPoLeHsDtmqLBZ2qm5Hu7e9tDR9Jv5RM' }

  it 'visiting as not signed in user', :vcr do
    visit "/polkadot/chains/#{chain.slug}/accounts/#{address}"

    expect(page).to have_content('1341kcAXqyA5ZJHBdPoLeHsDtmqLBZ2qm5Hu7e9tDR9Jv5RM')
    expect(page).to have_content('XiaoGong')
    expect(page).to have_content('0.305')
  end
end
