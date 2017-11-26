require 'rails_helper'

RSpec.describe Hunt, type: :model do
  before (:each) do
    @hunt = Hunt.create(user: User.first, location: Location.first, name: "Test Hunt", start_time: DateTime.new(2018, 1, 1, 12, 00, 00), finish_time: DateTime.new(2018, 1, 1, 15, 00, 00))
  end

  it 'has a user' do
    expect(@hunt.user).to eq(User.first)
  end

  it 'has many items' do
    @hunt.items << Item.new(name: "Ball")
    @hunt.items << Item.new(name: "Stick")
    expect(@hunt.items.count).to eq(2)
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

  it 'a new hunt has a default status of pending' do
    hunt = Hunt.create(user: User.first, location: Location.first, start_time: DateTime.new(2018, 1, 1, 12, 00, 00), finish_time: DateTime.new(2018, 1, 1, 15, 00, 00), name: "Test Hunt")
    expect(hunt.status).to eq("pending")
  end

  it 'has a method to display all pending hunts' do
    count = Hunt.pending.count
    Hunt.create(user: User.first, name: "Test Hunt", location: Location.first, start_time: DateTime.new(2018, 1, 1, 12, 00, 00), finish_time: DateTime.new(2018, 1, 1, 15, 00, 00))
    expect(Hunt.pending.count).to eq(count + 1)
  end

  it 'has a method to display all active hunts' do
    count = Hunt.active.count
    Hunt.create(user: User.first, location: Location.first, start_time: DateTime.new(2018, 1, 1, 12, 00, 00), finish_time: DateTime.new(2018, 1, 1, 15, 00, 00), status: "active", name: "Test Hunt")
    expect(Hunt.active.count).to eq(count + 1)
  end

  it 'has a method to display all completed hunts' do
    count = Hunt.completed.count
    Hunt.create(user: User.first, location: Location.first, start_time: DateTime.new(2018, 1, 1, 12, 00, 00), finish_time: DateTime.new(2018, 1, 1, 15, 00, 00), status: "completed", name: "Test Hunt")
    expect(Hunt.completed.count).to eq(count + 1)
  end

  it 'requires a name, location, start and finish time' do
    no_name = Hunt.new(location: Location.first, start_time: DateTime.new(2018, 1, 1, 12, 00, 00), finish_time: DateTime.new(2018, 1, 1, 15, 00, 00), user: User.first)
    no_location = Hunt.new(name: "Test Hunt", start_time: DateTime.new(2018, 1, 1, 12, 00, 00), finish_time: DateTime.new(2018, 1, 1, 15, 00, 00), user: User.first)
    no_start = Hunt.new(name: "Test Hunt", location: Location.first, finish_time: DateTime.new(2018, 1, 1, 15, 00, 00), user: User.first)
    no_end = Hunt.new(name: "Test Hunt", location: Location.first, start_time: DateTime.new(2018, 1, 1, 12, 00, 00), user: User.first)
    hunt = Hunt.new(name: "Test Hunt", location: Location.first, start_time: DateTime.new(2018, 1, 1, 12, 00, 00), finish_time: DateTime.new(2018, 1, 1, 15, 00, 00), user: User.first)

    expect(no_name.valid?).to eq(false)
    expect(no_location.valid?).to eq(false)
    expect(no_start.valid?).to eq(false)
    expect(no_end.valid?).to eq(false)
    expect(hunt.valid?).to eq(true)
  end

  it 'is invalid if the end time is before the start time' do
    hunt = Hunt.new(user: User.first, name: "Test Hunt", location: Location.first, finish_time: '2018, 1, 1, 12, 00, 00', start_time: '2018, 1, 1, 15, 00, 00')
    expect(hunt.valid?).to eq(false)
  end

  it 'cannot be instantiated with a date in the past' do
    hunt = Hunt.new(user: User.first, name: "Test Hunt", location: Location.first, start_time: DateTime.new(2016, 1, 1, 12, 00, 00), finish_time: DateTime.new(2016, 1, 1, 15, 00, 00))
    expect(hunt.valid?).to eq(false)
  end

  it 'has a method to display the date' do
    expect(@hunt.date).to eq("Monday, January 1, 2018")
  end
end
