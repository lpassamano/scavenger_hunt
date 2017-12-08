require 'rails_helper'

RSpec.describe Team, type: :model do
  before (:each) do
    @user1 = User.create(name: Faker::Internet.user_name, email: Faker::Internet.email, password: "password123")
    @user2 = User.create(name: Faker::Internet.user_name, email: Faker::Internet.email, password: "password123")
    @user3 = User.create(name: Faker::Internet.user_name, email: Faker::Internet.email, password: "password123")
    @hunt = Hunt.create(location: Location.first, start_time: DateTime.new(2018, 1, 1, 12, 00, 00), finish_time: DateTime.new(2018, 1, 1, 15, 00, 00), owner: @user1, name: "Test Hunt")
    @team = @hunt.teams.build
    @hunt.items.build(name: "Test Item")
    @hunt.save
  end

  it 'has a hunt' do
    @team.hunt = @hunt
    @team.save

    expect(@team.hunt).to eq(Hunt.last)
  end

  it 'has many participants' do
    @team.participants << @user2
    @team.participants << @user3

    expect(@team.participants.to_a.count).to eq(2)
  end

  it 'has many found items' do
    expect(@team.found_items.count).to eq(1)
  end

  it 'will generate a name if one is not given at initialization' do
    team = Team.create(hunt: Hunt.first)
    expect(team.name).to eq("Team #{team.id}")
  end

  it 'lists items that still need to be found' do
    @team.found_items << FoundItem.create(item: Item.create(name: "item"), found: false)
    @team.found_items << FoundItem.create(item: Item.create(name: "black cat"), found: true)
    expect(@team.missing_items.count).to eq(2)
  end

  it 'upon instantiation will create a found_item for every item its hunt has' do
    num_items = @team.items.count
    new_team = @hunt.teams.build
    @hunt.save

    expect(new_team.items.count).to eq(num_items)
  end
end
