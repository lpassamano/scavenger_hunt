require 'rails_helper'

RSpec.describe User, type: :model do
  before (:each) do
    #create a user
    @user = User.first
    @hunt1 = Hunt.new
    @hunt2 = Hunt.new
    @hunt3 = Hunt.new
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
    @user.teams << Team.new
    expect(@user.teams.count).to eq(1)
  end

  it 'has a current team' do
  end

  it 'has a unique email and username' do

  end
end
