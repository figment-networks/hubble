FactoryBot.define do
  factory :alertable_address do
    chain { create(:oasis_chain) }
    address { 'oasis1qzhwl87e7d6up3tf3wu08e9n8gqk6vkw2v8gqc2j' }
  end
end
