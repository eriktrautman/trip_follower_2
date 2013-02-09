FactoryGirl.define do
  factory :user do
    sequence(:fname)  { |n| "Special#{n}" }
    sequence(:lname)  { |n| "Person#{n}"}
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"
  end

  factory :life_thread do
    sequence(:name) { |n| "Trip Thread #{n}" }
    sequence(:tagline) { |n| "Cool Trip Number #{n}!" }
    sequence(:description) { |n| "Lorem ipsum dolor sit amet, consectetur adipisicing elit. At minus doloribus numquam ratione facere tempora atque reiciendis ut iure sapiente optio earum unde nostrum illo repellendus velit delectus vel quidem."}
    sequence(:hashtag) { |n| "tag#{n}" }
    association :creator, factory: :user
  end

end