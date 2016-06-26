FactoryGirl.define do
  factory :dish do
    name { Faker::Name.name }
    description { Faker::Lorem.sentence(10) }
    association :creator, factory: :admin
  end
end
