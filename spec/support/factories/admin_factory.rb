FactoryBot.define do
  factory :admin, class: Administrator do
    name { "Admin" }
    email { "admin@figment.network" }
    password { "AdminPass123" }
  end
end
