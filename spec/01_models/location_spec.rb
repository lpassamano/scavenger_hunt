require 'rails_helper'

RSpec.describe Location, type: :model do
  before (:each) do
    @location = Location.create(city: "Los Angeles", state: "CA")
  end

  it 'has many hunts' do
    @location.hunts << Hunt.find(1)
    expect(@location.hunts.count).to eq(1)
  end

  it 'is invalid if the city given is not in the state given' do
    location = Location.new(city: "New York", state: "NJ")
    expect(location.valid?).to eq(false)
  end
end
