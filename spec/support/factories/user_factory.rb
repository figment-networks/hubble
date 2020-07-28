FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User ##{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { '12345678' }
  end
end
