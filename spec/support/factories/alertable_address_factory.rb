FactoryBot.define do
  factory :alertable_address do
    chain { create(:oasis_chain) }
    address { 'oasis1qz72lvk2jchk0fjrz7u2swpazj3t5p0edsdv7sf8' }
  end
end
