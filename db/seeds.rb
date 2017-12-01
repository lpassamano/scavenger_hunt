## Create Users ##
25.times do
  User.create(
    name: Faker::Internet.user_name,
    email: Faker::Internet.email,
    password: "password123"
  )
end

Location.create(city: "New York", state: "NY")
Location.create(city: "Los Angeles", state: "CA")
Location.create(city: "Dallas", state: "TX")

## Create Hunts ##
10.times do
  user = rand(1..25)
  location = rand(1..3)
  start = (DateTime.current + rand(1..365).days).to_datetime
  finish = (start + 2.hours).to_datetime

  Hunt.create(
    user_id: user,
    location_id: location,
    name: Faker::Zelda.location,
    start_time: start,
    finish_time: finish
  )
end

## Add Items to Hunts ##
## Add Teams to Hunts ##
## Add FoundItems for Item/Team ##
Hunt.all.each do |hunt|
  10.times do
    Item.create(
      name: Faker::Zelda.item,
      hunt: hunt
    )
  end

  5.times do
    team = Team.create(hunt: hunt)

    hunt.items.each do |item|
      item.found_items << FoundItem.new(team: team)
      item.save
    end
  end
end

## Assign Users to Teams ##
max = Team.all.count
User.all.each do |user|
  user.team_participants << TeamParticipant.new(team_id: rand(1..max))
  user.save
end
