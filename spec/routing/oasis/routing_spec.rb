require 'rails_helper'

RSpec.describe 'chain routes' do
  let(:chain) { create(:oasis_chain, slug: 'OASIS-SLUG') }
  
  it 'allows routing to chain with uppercase letters in slug' do
    expect(:get => "/oasis/chains/#{chain.slug}").to route_to(
      network: 'oasis',
      controller: 'oasis/chains',
      action: 'show',
      id: chain.slug
    )
  end
end
