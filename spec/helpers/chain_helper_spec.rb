require 'rails_helper'

describe ChainHelper do
  describe '#grouped_visible_chains' do
    subject { grouped_visible_chains }

    let!(:polkadot_chain_1) { create(:polkadot_chain) }
    let!(:cosmos_chain) { create(:cosmos_chain) }
    let!(:polkadot_chain_2) { create(:polkadot_chain) }
    let!(:near_chain) { create(:near_chain) }

    it 'grouped chains' do
      expect(subject).to eq({ 'Cosmos' => [cosmos_chain], 'NEAR' => [near_chain],
                              'Polkadot' => [polkadot_chain_1, polkadot_chain_2] })
    end
  end
end
