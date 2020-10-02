require 'rails_helper'

describe Polkadot::AccountDetailsDecorator do
  describe '#identity_fields' do
    subject { described_class.new(model).identity_fields }

    let(:model) { double(legal_name: 'name', web_name: "\u0017some web name", riot_name: 'Johny Depp', email_name: '', twitter_name: nil) }

    it 'returns an array of hashes in proper format, without empty values' do
      expect(subject).to eq [
        { label: 'Legal name', value: 'name' },
        { label: 'Web name', value: 'some web name' },
        { label: 'Riot name', value: 'Johny Depp' }
      ]
    end
  end
end
