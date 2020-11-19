require 'rails_helper'

describe FormattingHelper do
  describe '#format_amount' do
    context 'with in_millions' do
      subject { format_amount(amount, chain, in_millions: true) }

      let(:amount) { 123000000 }
      let(:chain) do
        double(token_map: { 'ungm' => { 'factor' => 6, 'display' => 'NGM', 'primary' => true } },
               primary_token: 'ungm')
      end

      it 'returns a value formatted in millions' do
        expect(subject).to eq "<span class='text-monospace'>123M</span> <span class='text-sm text-muted sup'>{\"factor\"=>6, \"display\"=>\"NGM\", \"primary\"=>true}</span>"
      end
    end
  end

  describe '#rounded_percentage' do
    subject { rounded_percentage(amount) }

    let(:amount) { 12 }

    it 'returns a correct percentage' do
      expect(subject).to eq '12.00'
    end

    context 'zero' do
      let(:amount) { 0 }

      it 'returns a correct percentage' do
        expect(subject).to eq '0.00'
      end
    end
  end
end
