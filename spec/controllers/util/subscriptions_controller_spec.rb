require 'rails_helper'

RSpec.describe Util::SubscriptionsController do
  let!(:cosmos_chain) { create(:cosmos_chain) }
  let!(:oasis_chain) { create(:oasis_chain, api_url: 'http://localhost:1111') }
  let!(:polkadot_chain) { create(:polkadot_chain, api_url: 'http://localhost:1111') }
  let!(:user) { create(:user) }
  let!(:cosmos_alertable) { create(:cosmos_validator, chain: cosmos_chain) }
  let!(:oasis_alertable) { create(:alertable_address, chain: oasis_chain) }
  let!(:polkadot_alertable) { create(:alertable_address, chain: polkadot_chain, address: '138QdRbUTB9eNY94Q4Mj5r39FkgMiyHCAy8UFMNA5gvtrfSB') }

  describe 'GET #index' do
    context 'when logged out' do
      it 'redirects to new_user_path' do
        get :index, params: { network: cosmos_chain.network_name.downcase,
                              chain_id: cosmos_chain.slug, validator_id: cosmos_alertable.address }
        expect(response).to redirect_to(new_user_path)
      end
    end

    context 'when logged in' do
      before { allow(controller).to receive(:current_user).and_return(user) }

      before do
        get :index, params: { network: cosmos_chain.network_name.downcase, chain_id: cosmos_chain.slug,
                              validator_id: cosmos_alertable.address }
      end

      it 'responds with 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the :index view' do
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'POST #create' do
    before { allow(controller).to receive(:current_user).and_return(user) }

    context 'Cosmos Subscription with valid subscription' do
      let(:alert_params) do
        { 'event_kinds' => { 'voting_power_change' => 'on', 'n_of_m' => 'off' },
          'data' => { 'percent_change' => '15.0' }, 'wants_daily_digest' => 'on' }
      end
      let(:params) do
        { network: cosmos_chain.network_name.downcase, chain_id: cosmos_chain.slug,
          validator_id: cosmos_alertable.address, alert_subscription: alert_params }
      end

      it 'saves the new subscription' do
        expect { post :create, params: params }.to change(AlertSubscription, :count).by(1)
      end

      it 'responds with 302 status' do
        post :create, params: params
        expect(response).to have_http_status(:found)
      end

      it 'shows confirmation notice' do
        post :create, params: params
        expect(flash[:notice]).to eq('Subscribed to events for this validator!')
      end
    end

    context 'Oasis Subscription with valid subscription' do
      let(:alert_params) do
        { 'event_kinds' => { 'voting_power_change' => 'on', 'n_of_m' => 'off' },
          'data' => { 'percent_change' => '15.0' }, 'wants_daily_digest' => 'on' }
      end
      let(:params) do
        { network: oasis_chain.network_name.downcase, chain_id: oasis_chain.slug,
          validator_id: oasis_alertable.address, alert_subscription: alert_params }
      end

      it 'saves the new subscription', :vcr do
        expect { post :create, params: params }.to change(AlertSubscription, :count).by(1)
      end

      it 'responds with 302 status', :vcr do
        post :create, params: params
        expect(response).to have_http_status(:found)
      end

      it 'shows confirmation notice', :vcr do
        post :create, params: params
        expect(flash[:notice]).to eq('Subscribed to events for this validator!')
      end
    end

    context 'Polkadot Subscription with valid subscription' do
      let(:alert_params) do
        { 'event_kinds' => { 'voting_power_change' => 'on', 'n_of_m' => 'off' },
          'data' => { 'percent_change' => '15.0' }, 'wants_daily_digest' => 'on' }
      end
      let(:params) do
        { network: polkadot_chain.network_name.downcase, chain_id: polkadot_chain.slug,
          validator_id: polkadot_alertable.address, alert_subscription: alert_params }
      end

      it 'saves the new subscription', :vcr do
        expect { post :create, params: params }.to change(AlertSubscription, :count).by(1)
      end

      it 'responds with 302 status', :vcr do
        post :create, params: params
        expect(response).to have_http_status(:found)
      end

      it 'shows confirmation notice', :vcr do
        post :create, params: params
        expect(flash[:notice]).to eq('Subscribed to events for this validator!')
      end
    end

    context 'Cosmos Subscription with nothing subscribed' do
      let(:alert_params) do
        { 'event_kinds' => { 'voting_power_change' => 'off', 'n_of_m' => 'off' },
          'wants_daily_digest' => 'off' }
      end
      let(:params) do
        { network: cosmos_chain.network_name.downcase, chain_id: cosmos_chain.slug,
          validator_id: cosmos_alertable.address, alert_subscription: alert_params }
      end

      it 'does not save the new subscription' do
        expect { post :create, params: params }.to change(AlertSubscription, :count).by(0)
      end

      it 'responds with 302 status' do
        post :create, params: params
        expect(response).to have_http_status(:found)
      end

      it 'shows confirmation notice' do
        post :create, params: params
        expect(flash[:notice]).to eq('No alerts selected. Subscription removed.')
      end
    end

    context 'Cosmos Subscription with invalid subscription' do
      let(:alert_params) do
        { 'foo' => 'on' }
      end
      let(:params) do
        { network: cosmos_chain.network_name.downcase, chain_id: cosmos_chain.slug,
          validator_id: cosmos_alertable.address, alert_subscription: alert_params }
      end

      it 'does not save the new subscription' do
        expect { post :create, params: params }.to change(AlertSubscription, :count).by(0)
      end

      it 'responds with 302 status' do
        post :create, params: params
        expect(response).to have_http_status(:found)
      end

      it 'shows confirmation notice' do
        post :create, params: params
        expect(flash[:notice]).to eq('No alerts selected. Subscription removed.')
      end
    end
  end
end
