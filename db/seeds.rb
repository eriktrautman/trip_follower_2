# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

names = ["foobar", "Emily", "Brynn", "Mindy", "David", "PowerUser", "Erik"]
places = ["Rome", "Paris", "The Beach", "NYC", "Boot Camp", "The Library"]

names.each do |name|
  u = User.create(username: name, email: "#{name}@example.com", password: "foobar",
      password_confirmation: "foobar")
  t = u.trips.create(name: "#{name}'s Trip",
                tagline: "#{name} goes to #{places.sample}",
                hashtag: "#{name}Trip",
                description: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
  t.trip_administratorings.create!(user: u)
  t.trip_whitelistings.create!(user: u)
  (User.all.size/2).times do
    u.user_followings.create( followed_id: User.all.sample.id)
  end
end