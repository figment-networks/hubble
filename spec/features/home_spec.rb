require 'features_helper'

describe 'homepage' do
  let!(:coda_main) { create :coda_chain, slug: 'main', primary: true }
  let!(:coda_test) { create :coda_chain, slug: 'testnet', primary: false }

  before do
    visit root_path
  end

  it 'displays primary coda chain' do
    expect(page).to have_link href: coda_chain_path(coda_main)
    expect(page).not_to have_link href: coda_chain_path(coda_test)
  end
end
