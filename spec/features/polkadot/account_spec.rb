require 'features_helper'

describe 'polkadot account details' do
  let(:chain) { create(:polkadot_chain) }
  let(:address) { 'DSpbbk6HKKyS78c4KDLSxCetqbwnsemv2iocVXwNe2FAvWC' }

  it 'visiting as not signed in user', :vcr do
    visit "/polkadot/chains/#{chain.slug}/accounts/#{address}"

    expect(page).to have_content('DSpbbk6HKKyS78c4KDLSxCetqbwnsemv2iocVXwNe2FAvWC')
    expect(page).to have_content('DragonStake')
    expect(page).to have_content('0.00002')
  end
end
