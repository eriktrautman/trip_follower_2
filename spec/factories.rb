FactoryGirl.define do
  factory :user do
    sequence(:fname)  { |n| "Special#{n}" }
    sequence(:lname)  { |n| "Person#{n}"}
    sequence(:email) { |n| "person_#{n}@example.com"}   
    password "foobar"
    password_confirmation "foobar"
  end

  
end