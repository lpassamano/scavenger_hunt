require 'rails_helper'

RSpec.describe Hunt, type: :model do
  before (:each) do
    @hunt = Hunt.create(user: User.first, location: Location.first)

    @hunt1 = Hunt.create(user: User.first, location: Location.first, status: "pending")
    @hunt2 = Hunt.create(user: User.first, location: Location.first, status: "active")
    @hunt3 = Hunt.create(user: User.first, location: Location.first, status: "completed")
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

  it 'has a method to display all pending hunts' do
    expect(Hunt.pending).to eq(1)
  end

  it 'has a method to display all active hunts' do
    expect(Hunt.active).to eq(1)
  end

  it 'has a method to display all completed hunts' do
    expect(Hunt.complete).to eq(1)
  end
end
