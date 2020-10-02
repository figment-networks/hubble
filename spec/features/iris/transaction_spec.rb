require 'features_helper'

describe 'Iris transaction details' do
  let(:chain) { create(:iris_chain) }
  let(:transaction_id) { '2f6218e0102c13781f23b83291d353ac3c3b3a5c3668ca95a82d405a13cb93b9' }
  let(:block_id) { 6702225 }

  it 'visiting Transaction View as not signed in user', :vcr do
    visit "/iris/chains/#{chain.slug}/blocks/#{block_id}/transactions/#{transaction_id}"
    expect(page).to have_content(chain.name)
    expect(page).to have_content(transaction_id)
    expect(page).to have_content(block_id)
    expect(page).to have_content('iaa1v8jnm52a4c204898v7nd2uq09cgl2hky0s00lk')
    expect(page).to have_content('iaa15m0yr8r5rqm5hwmd5hsyjrpwy02gsm95wuu0pz')
    expect(page).to have_content('1,151.672 IRIS')
    expect(page).to have_content('5,017 GAS')
  end
end
