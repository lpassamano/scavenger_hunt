# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

5.times do
  User.create(
    name: Faker::Internet.user_name,
    email: Faker::Internet.email,
    password: "password123"
  )
end

3.times do
  Hunt.create(
    user: User.first,
    location: Location.first,
    name: Faker::Zelda.location,
    start_time: DateTime.new(2018, 1, 1, 12, 00, 00),
    finish_time: DateTime.new(2018, 1, 1, 15, 00, 00),
    status: "pending"
  )
end

Location.create(city: "New York", state: "NY")


## Hunt needs a user_id in order to be saved to the db!
#20.times do
#  Hunt.create(
#    #add in stuff later
#  )
#end
