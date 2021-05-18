require 'rails_helper'

RSpec.describe Skale::Chain do
  let!(:chain) { build(:skale_chain) }

  include_examples 'default token display'

  describe '#token_map' do
    context 'with a slug not specified in class token_map' do
      it 'returns the default value' do
        chain.slug = 'asdf'
        expected_value = described_class.token_map['default']
        expect(chain.token_map).to eq expected_value
      end
    end

    context 'with a slug specified in class token_map' do
      it 'returns the correct value' do
        chain.slug = 'default'
        expected_value = described_class.token_map['default']
        expect(chain.token_map).to eq expected_value
      end
    end
  end
end
