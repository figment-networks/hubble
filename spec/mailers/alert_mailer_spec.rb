require 'rails_helper'

RSpec.describe AlertMailer do
  describe '#instant' do
    let(:sub) { create(:alert_subscription, alertable: alertable) }
    let(:events) { create_list(:cosmos_event, 5) }

    let(:email) { AlertMailer.with(sub: sub, events: events).instant }

    context 'with an alertable address' do
      let(:alertable) { create(:alertable_address) }

      it 'sends an instant alert' do
        allow(alertable).to receive(:long_name).and_return('Test')

        expect(email.from).to contain_exactly('notifications@figment.io')
        expect(email.to).to contain_exactly(sub.user.email)

        expect(email.subject).to eq('HUBBLE ALERT - Test on Oasis/OasisChain (5 new events)')

        assert_emails 1 do
          email.deliver_now
        end
      end
    end

    context 'with a delegator list' do
      let(:alertable) { create(:livepeer_delegator_list, name: 'Test') }

      it 'sends an instant alert' do
        expect(email.from).to contain_exactly('notifications@figment.io')
        expect(email.to).to contain_exactly(sub.user.email)

        expect(email.subject).to eq('HUBBLE ALERT - Test on Livepeer/Mainnet (5 new events)')

        assert_emails 1 do
          email.deliver_now
        end
      end
    end
  end

  describe '#daily' do
    let(:sub) { create(:alert_subscription, alertable: alertable, wants_daily_digest: true) }
    let(:date) { 4.days.ago }
    let(:events) { create_list(:cosmos_event, 5) }

    let(:email) { AlertMailer.with(sub: sub, date: date, events: events).daily }

    context 'with an alertable address' do
      let(:alertable) { create(:alertable_address) }

      it 'sends a daily digest' do
        allow(alertable).to receive(:long_name).and_return('Test')

        expect(email.from).to contain_exactly('notifications@figment.io')
        expect(email.to).to contain_exactly(sub.user.email)

        expect(email.subject).to eq('HUBBLE DAILY DIGEST - Test on Oasis/OasisChain (5 new events)')

        assert_emails 1 do
          email.deliver_now
        end
      end
    end

    context 'with a delegator list' do
      let(:alertable) { create(:livepeer_delegator_list, name: 'Test') }

      it 'sends a daily digest' do
        expect(email.from).to contain_exactly('notifications@figment.io')
        expect(email.to).to contain_exactly(sub.user.email)

        expect(email.subject).to eq('HUBBLE DAILY DIGEST - Test on Livepeer/Mainnet (5 new events)')

        assert_emails 1 do
          email.deliver_now
        end
      end
    end
  end
end
