FactoryBot.define do
  factory :admin, class: 'Administrator' do
    name { 'Admin' }
    email { 'admin@figment.io' }
    password { 'AdminPass123' }
  end
end
