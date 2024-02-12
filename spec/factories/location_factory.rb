FactoryBot.define do
  factory :location do
    name { Faker::Address.city }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    state { Faker::Address.state }
    country { Faker::Address.country }
  end
end
