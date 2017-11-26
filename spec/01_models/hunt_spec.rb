require 'rails_helper'

RSpec.describe Hunt, type: :model do
  before (:each) do
    @hunt = Hunt.create(user: User.first, location: Location.first)
  end

  it 'has a user' do
    expect(@hunt.user).to eq(User.first)
  end

  it 'has many items' do
    @hunt.items << Item.new
    @hunt.items << Item.new

    expect(@hunt.items.count).to eq(2)
  end

  it 'has a location' do
    @hunt.location = Location.create
    expect(@hunt.location).to eq(Location.last)
  end

  it 'has many teams' do
    @hunt.teams << Team.new
    @hunt.teams << Team.new

    expect(@hunt.teams.count).to eq(2)
  end

  it 'a new hunt has a default status of pending' do
    hunt = Hunt.create(user: User.first, location: Location.first)
    expect(hunt.status).to eq("pending")
  end

  it 'has a method to display all pending hunts' do
    count = Hunt.pending.count
    Hunt.create(user: User.first, location: Location.first)
    expect(Hunt.pending.count).to eq(count + 1)
  end

  it 'has a method to display all active hunts' do
    count = Hunt.active.count
    Hunt.create(user: User.first, location: Location.first, status: "active")
    expect(Hunt.active.count).to eq(count + 1)
  end

  it 'has a method to display all completed hunts' do
    count = Hunt.completed.count
    Hunt.create(user: User.first, location: Location.first, status: "completed")
    expect(Hunt.completed.count).to eq(count + 1)
  end
end
