require 'features_helper'

describe 'homepage' do
  let!(:mina_main) { create :mina_chain, slug: 'main', primary: true }
  let!(:mina_test) { create :mina_chain, slug: 'testnet', primary: false }

  before do
    visit root_path
  end

  it 'displays primary mina chain' do
    expect(page).to have_link href: mina_chain_path(mina_main)
    expect(page).not_to have_link href: mina_chain_path(mina_test)
  end
end
