# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

25.times do
  User.create(
    name: Faker::Internet.user_name,
    email: Faker::Internet.email,
    password: "password123"
  )
end

Location.create(city: "New York", state: "NY")

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

15.times do
  Item.create(
    name: Faker::Cat.breed,
    hunt: Hunt.first
  )
end

5.times do
  Team.create(
    hunt: Hunt.first
  )

  team = Team.last
  item_id = 1

  15.times do
    team.found_items << FoundItem.new(item_id: item_id)
    team.save
    item_id += 1
  end
end

team_id = 1
User.all.each do |user|
  user.team_participants << TeamParticipant.new(team_id: team_id)
  user.current_team_id = team_id
  user.save
  if team_id == 5
    team_id = 1
  else
    team_id += 1
  end
end
