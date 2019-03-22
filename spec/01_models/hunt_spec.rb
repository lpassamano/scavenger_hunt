require 'rails_helper'

RSpec.describe Hunt, type: :model do

  before (:each) do
    @hunt = Hunt.create(owner: User.first, location: Location.first, name: "Test Hunt", start_time: DateTime.new(2058, 1, 1, 12, 00, 00), finish_time: DateTime.new(2058, 1, 1, 15, 00, 00), meeting_place: Faker::Address.street_address)
  end

  it 'has a user' do
    expect(@hunt.owner).to eq(User.first)
  end

  it 'has many items' do
    @hunt.items << Item.new(name: "Ball")
    @hunt.items << Item.new(name: "Stick")
    expect(@hunt.items.count).to eq(2), "expected: 2\ngot: #{@hunt.items.count}\nIF THIS IS FAILING CHECK THE START/FINISH TIMES OF THE TEST HUNT!"
  end

  it 'has a location' do
    @hunt.location = Location.create(city: "Los Angeles", state: "CA")
    expect(@hunt.location).to eq(Location.last)
  end

  it 'has many teams' do
    @hunt.teams << Team.new
    @hunt.teams << Team.new

    expect(@hunt.teams.count).to eq(2)
  end

  it 'has a default status of pending' do
    hunt = Hunt.create(owner: User.first, location: Location.first, start_time: DateTime.new(2058, 1, 1, 12, 00, 00), finish_time: DateTime.new(2058, 1, 1, 15, 00, 00), name: "Test Hunt", meeting_place: Faker::Address.street_address)
    expect(hunt.status).to eq("pending")
  end

  it 'has a method to display all pending hunts' do
    count = Hunt.pending.count
    pending_hunt = Hunt.create(owner: User.first, name: "Test Hunt", location: Location.first, start_time: DateTime.new(2058, 1, 1, 12, 00, 00), finish_time: DateTime.new(2058, 1, 1, 15, 00, 00), meeting_place: Faker::Address.street_address)
    expect(Hunt.pending.count).to eq(count + 1)
    expect(Hunt.pending).to include(pending_hunt)
  end

  it 'has a method to display all active hunts' do
    count = Hunt.active.count
    active_hunt = Hunt.create(owner: User.first, location: Location.first, name: "Test Hunt", start_time: DateTime.current, finish_time: DateTime.new(2058, 1, 1, 15, 00, 00), meeting_place: Faker::Address.street_address)
    expect(Hunt.active.count).to eq(count + 1)
    expect(Hunt.active).to include(active_hunt)
  end

  it 'has a method to display all completed hunts' do
    count = Hunt.completed.count
    completed_hunt = Hunt.create(owner: User.first, location: Location.first, name: "Test Hunt", start_time: DateTime.current, finish_time: DateTime.current, meeting_place: Faker::Address.street_address)
    expect(Hunt.completed.count).to eq(count + 1)
    expect(Hunt.completed).to include(completed_hunt)
  end

  it 'requires a name, location, meeting_place, start and finish time' do
    no_name = Hunt.new(location: Location.first, start_time: DateTime.new(2058, 1, 1, 12, 00, 00), finish_time: DateTime.new(2058, 1, 1, 15, 00, 00), owner: User.first, meeting_place: Faker::Address.street_address)
    no_location = Hunt.new(name: "Test Hunt", start_time: DateTime.new(2058, 1, 1, 12, 00, 00), finish_time: DateTime.new(2058, 1, 1, 15, 00, 00), owner: User.first, meeting_place: Faker::Address.street_address)
    no_meeting_place = Hunt.new(name: "Test Hunt", location: Location.first, start_time: DateTime.new(2058, 1, 1, 12, 00, 00), finish_time: DateTime.new(2058, 1, 1, 15, 00, 00), owner: User.first)
    no_start = Hunt.new(name: "Test Hunt", location: Location.first, finish_time: DateTime.new(2058, 1, 1, 15, 00, 00), owner: User.first, meeting_place: Faker::Address.street_address)
    no_end = Hunt.new(name: "Test Hunt", location: Location.first, start_time: DateTime.new(2058, 1, 1, 12, 00, 00), owner: User.first, meeting_place: Faker::Address.street_address)
    hunt = Hunt.new(name: "Test Hunt", location: Location.first, start_time: DateTime.new(2058, 1, 1, 12, 00, 00), finish_time: DateTime.new(2058, 1, 1, 15, 00, 00), owner: User.first, meeting_place: Faker::Address.street_address)

    expect(no_name.valid?).to eq(false)
    expect(no_location.valid?).to eq(false)
    expect(no_meeting_place.valid?).to eq(false)
    expect(no_start.valid?).to eq(false)
    expect(no_end.valid?).to eq(false)
    expect(hunt.valid?).to eq(true)
  end

  it 'is invalid if the end time is before the start time' do
    hunt = Hunt.new(owner: User.first, name: "Test Hunt", location: Location.first, finish_time: '2018, 1, 1, 12, 00, 00', start_time: '2018, 1, 1, 15, 00, 00', meeting_place: Faker::Address.street_address)
    expect(hunt.valid?).to eq(false)
  end

  it 'cannot be instantiated with a date in the past' do
    hunt = Hunt.new(owner: User.first, name: "Test Hunt", location: Location.first, start_time: DateTime.new(2016, 1, 1, 12, 00, 00), finish_time: DateTime.new(2016, 1, 1, 15, 00, 00), meeting_place: Faker::Address.street_address)
    expect(hunt.valid?).to eq(false)
  end

  it 'updates the status of the hunt to active at start time and completed at end time' do
    @hunt.start_time = DateTime.new(2017, 11, 28, 12, 00, 00)
    expect(@hunt.status).to eq("active")

    @hunt.finish_time = DateTime.new(2017, 11, 28, 13, 00, 00)
    expect(@hunt.status).to eq("completed")
  end

  it 'has a method to display the date' do
    expect(@hunt.date).to eq("Tue, January 1 at 12:00pm - 3:00pm")
  end
end
