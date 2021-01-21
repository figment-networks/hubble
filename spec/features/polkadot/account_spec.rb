require 'features_helper'

describe 'polkadot account details' do
  let(:chain) { create(:polkadot_chain) }
  let(:address) { '1341kcAXqyA5ZJHBdPoLeHsDtmqLBZ2qm5Hu7e9tDR9Jv5RM' }

  it 'visiting as not signed in user', :vcr do
    visit "/polkadot/chains/#{chain.slug}/accounts/#{address}"

    expect(page).to have_content('1341kcAXqyA5ZJHBdPoLeHsDtmqLBZ2qm5Hu7e9tDR9Jv5RM')
    expect(page).to have_content('XiaoGong')
    expect(page).to have_content('455439044@qq.com')
    expect(page).to have_content('Account Details')
    expect(page).to have_content('DEPOSITS')
    expect(page).to have_content('BONDED')
    expect(page).to have_content('WITHDRAWN')
    expect(page).to have_content('BALANCE')
    expect(page).to have_content('RESERVED')
    expect(page).to have_content('FROZEN')
  end
end
