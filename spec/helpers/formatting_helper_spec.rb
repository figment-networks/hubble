require 'rails_helper'

describe FormattingHelper do
  describe '#format_amount' do
    context 'with in_millions' do
      subject { format_amount(amount, chain, in_millions: true) }

      let(:amount) { 123000000000000 }
      let(:chain) do
        double(token_map: { 'ungm' => { 'factor' => 6, 'display' => 'NGM', 'primary' => true } },
               primary_token: 'ungm')
      end

      it 'returns a value formatted in millions' do
        expect(subject).to eq "<span class='text-monospace'>123M</span> <span class='text-sm text-muted sup'>NGM</span>"
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

  describe '#round_if_whole' do
    subject { round_if_whole(amount, precision) }

    let(:amount) { nil }
    let(:precision) { 3 }

    context 'nil' do
      it 'returns 0' do
        expect(subject).to eq 0
      end
    end

    context 'precision 2' do
      let(:amount) { 1.21212 }
      let(:precision) { 2 }

      it 'returns 1.23' do
        expect(subject).to eq 1.21
      end
    end

    context '0.00005' do
      let(:amount) { 0.00005 }

      it 'returns 0.00005' do
        expect(subject).to eq 0.00005
      end

      it 'to_s returns "0.00005"' do
        expect(subject.to_s).to eq '0.00005'
      end
    end

    context 'very small amount' do
      let(:amount) { 0.000001 }

      it 'returns 0' do
        expect(subject).to eq 0
      end
    end
  end
end
