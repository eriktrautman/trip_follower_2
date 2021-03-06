FactoryGirl.define do
  factory :user do
    sequence(:username)  { |n| "Person#{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"
  end

  factory :trip do
    sequence(:name) { |n| "Trip trip #{n}" }
    sequence(:tagline) { |n| "Cool Trip Number #{n}!" }
    sequence(:description) { |n| "Lorem ipsum dolor sit amet, consectetur adipisicing elit. At minus doloribus numquam ratione facere tempora atque reiciendis ut iure sapiente optio earum unde nostrum illo repellendus velit delectus vel quidem."}
    sequence(:hashtag) { |n| "tag#{n}" }
    association :creator, factory: :user

    after(:create) do |trip|
      FactoryGirl.create(:trip_administratoring, user: trip.creator, trip: trip)
      FactoryGirl.create(:trip_whitelisting, user: trip.creator, trip: trip)
    end
  end

  factory :event do
    sequence(:name) { |n| "Event #{n}" }
    sequence(:hashtag) { |n| "tag#{n}" }
    association :creator, factory: :user
    association :trip, factory: :trip
  end

  factory :trip_administratoring do
    user
    trip
  end

  factory :trip_whitelisting do
    user
    trip
  end

end