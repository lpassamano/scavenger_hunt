require 'rails_helper'

RSpec.describe User, type: :model do
  before (:each) do
    @user = User.create(name: Faker::Internet.user_name, email: Faker::Internet.email, password: "password123")
    @hunt1 = Hunt.new(location: Location.first, start_time: '2018, 1, 1, 12, 00, 00', finish_time: '2018, 1, 1, 15, 00, 00', name: "Test Hunt 1")
    @hunt2 = Hunt.new(location: Location.first, start_time: '2018, 1, 1, 12, 00, 00', finish_time: '2018, 1, 1, 15, 00, 00', name: "Test Hunt 2")
    @hunt3 = Hunt.new(location: Location.first, start_time: '2018, 1, 1, 12, 00, 00', finish_time: '2018, 1, 1, 15, 00, 00', name: "Test Hunt 3")
  end

  it 'has many hunts' do
    @user.hunts << @hunt1
    @user.hunts << @hunt2
    @user.hunts << @hunt3

    expect(@user.hunts.count).to eq(3)
  end

  it 'has many items' do
    @user.hunts << @hunt1
    @hunt1.items << Item.new
    expect(@user.items.count).to eq(1)
  end

  it 'has many teams' do
    @user.teams << Team.new(hunt: @hunt1)
    expect(@user.teams.count).to eq(1)
  end

  it 'has a current team' do
    @user.current_team = Team.create(hunt: @hunt1)
    expect(@user.current_team).to eq(Team.last)
  end

  it 'has a unique email and username' do
    u = User.new(name: @user.name, email: "email@email.com", password: "password123")
    expect(u.valid?).to eq(false)

    u = User.new(name: "username123", email: @user.email, password: "password123")
    expect(u.valid?).to eq(false)
  end
end
