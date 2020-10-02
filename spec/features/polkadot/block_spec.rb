require 'features_helper'

describe 'polkadot blocks' do
  let!(:chain) { create(:polkadot_chain) }
  let(:block_id) { '3189176' }

  it_behaves_like 'block view', 'polkadot'
end
