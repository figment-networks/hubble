require 'features_helper'

describe 'oasis blocks' do
  let!(:chain) { create(:oasis_chain, api_url: 'https://localhost:1111') }
  let(:block_id) { 1234 }

  context 'logged out' do
    it_behaves_like 'block view', 'oasis'
  end

  context 'logged in' do
    # to be further scoped out when logged in features become available
  end
end
