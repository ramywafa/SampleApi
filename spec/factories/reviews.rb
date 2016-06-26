FactoryGirl.define do
  factory :review do
    rating { Faker::Number.between(1, 5) }
    content { Faker::Lorem.sentence(10) }
    association :reviewer, factory: :admin
    association :dish, factory: :dish
  end

  factory :user_review, parent: :review do
    association :reviewer, factory: :user
  end
end
