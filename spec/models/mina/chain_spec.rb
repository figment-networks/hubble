require 'rails_helper'

RSpec.describe Mina::Chain do
  let!(:chain) { build(:mina_chain) }

  include_examples 'default token display'

  describe '#token_map' do
    context 'with a slug not specified in class token_map' do
      it 'returns the default value' do
        chain.slug = 'asdf'
        expected_value = described_class.token_map['default']
        expect(chain.token_map).to eq expected_value
      end
    end
  end
end
