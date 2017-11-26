require 'rails_helper'

RSpec.describe User, type: :model do
  before (:each) do
    #create a user
    @user = User.first
  end

  it 'has many hunts' do
    @user.hunts << Hunt.find(1)
    @user.hunts << Hunt.find(2)
    @user.hunts << Hunt.find(3)

    expect(@user.hunts.count).to eq(3)
  end

  it 'has many items' do

  end

  it 'has many teams' do

  end

  it 'has a current team' do

  end
end
