require 'rails_helper'

RSpec.describe Prime::HomeController do
  let!(:user) { create(:user) }
  let!(:prime_user) { create(:user, prime: true) }

  describe 'GET #index' do
    context 'not signed in' do
      it 'redirects to login' do
        expect(get(:index)).to redirect_to(login_path)
        expect(flash[:warning]).to eq('You must be logged in to access the Prime Dashboard.')
      end
    end

    context 'signed in non-prime user' do
      it 'redirects to hubble' do
        session[:uid] = user.id
        expect(get(:index)).to redirect_to(root_path)
        expect(flash[:warning]).to eq('To access Prime Dashboard, please contact andres@figment.io.')
      end
    end

    context 'signed in prime user' do
      it 'renders Prime Home #index' do
        session[:uid] = prime_user.id
        expect(get(:index)).to render_template(:index)
      end
    end
  end
end
