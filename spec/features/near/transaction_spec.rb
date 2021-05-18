require 'features_helper'

describe 'near transaction page' do
  let(:chain) { create(:near_chain) }

  let(:transaction_id) { 'BUUDuAJMVJuwc7Rk3ERHtog5n1UDYHj6B19JZW1o5Y1N' }
  let(:block_id) { 30025735 }

  it 'visiting transaction details', :vcr do
    visit "/near/chains/#{chain.slug}/blocks/#{block_id}/transactions/#{transaction_id}"
    expect(page).to have_content('BUUDuAJMVJuwc7Rk3ERHtog5n1UDYHj6B19JZW1o5Y1N')
  end
end
