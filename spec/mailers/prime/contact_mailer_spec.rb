require 'rails_helper'

RSpec.describe Prime::ContactMailer do
  describe '#user_submit' do
    let(:form) do
      { 'name' => 'Adam Van Der Beek',
        'company' => 'Figment',
        'email' => 'adam.vanderbeek@gmail.com',
        'tokens' => 'Cosmos, Terra, Near',
        'balance' => '$123,456,789.00' }
    end

    let(:email) { Prime::ContactMailer.with(form: form).user_submit }

    it 'sends a user submission email' do
      expect(email.from).to contain_exactly('notifications@figment.io')
      expect(email.to).to contain_exactly('sales@figment.io')

      expect(email.body).to have_content(form['name'])
      expect(email.body).to have_content(form['email'])
      expect(email.body).to have_content(form['company'])
      expect(email.body).to have_content(form['tokens'])
      expect(email.body).to have_content(form['balance'])

      assert_emails 1 do
        email.deliver_now
      end
    end
  end
end
