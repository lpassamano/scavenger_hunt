## Active Hunt: 1
## Completed Hunt: 2
## Pending Hunt: 3
## All Test Hunts Owner: 1
## All Test Teams Participant: 2


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
  start = (DateTime.current + rand(0..30).days).to_datetime
  finish = (start + 2.hours).to_datetime

  Hunt.create(
    user_id: user,
    location_id: location,
    name: Faker::Zelda.location,
    start_time: start,
    finish_time: finish
  )
end

## Make one owner for Hunt of each status ##
owner = User.find(1)

## Make one Hunt Active ##
h = Hunt.find(1)
h.start_time = (DateTime.current + 1.seconds)
h.finish_time = (DateTime.current + 1.years)
h.name = "Active Hunt"
h.owner = owner
h.save

## Make one Hunt Completed ##
h = Hunt.find(2)
h.start_time = (DateTime.current + 1.seconds)
h.finish_time = (DateTime.current + 2.seconds)
h.name = "Completed Hunt"
h.owner = owner
h.save

## Add one pending Hunt ##
h = Hunt.find(3)
h.name = "Pending Hunt"
h.owner = owner
h.save

## Make one team for each Hunt ##
active_team = Team.create(hunt_id: 1)
completed_team = Team.create(hunt_id: 2)
pending_team = Team.create(hunt_id: 3)

## Make one participant on Team for Active Hunt ##
active_team.participants << User.find(2)
completed_team.participants << User.find(2)
pending_team.participants << User.find(2)

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
