require 'rails_helper'

RSpec.describe Location, type: :model do
  before (:each) do
    @location = Location.create(city: "Los Angeles", state: "CA")
  end

  it 'has many hunts' do
    @location.hunts << Hunt.find(1)
    expect(@location.hunts.count).to eq(1)
  end

  it 'is invalid given a state that is not a two letter abbreviation' do
    location = Location.new(city: "Somewhere", state: "Somewhere")
    expect(location.valid?).to be(false)
  end
end
