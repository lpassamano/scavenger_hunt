require 'rails_helper'

RSpec.describe Location, type: :model do
  it 'has a working factory' do
    location = create :location
    location2 = create :location

    expect(location).to_not eq(location2)
  end

  it 'is invalid if the city given is not in the state given' do
    location = build :location, city: "New York", state: "NJ"
    expect(location.valid?).to eq(false)
  end

  it 'lists all pending hunts in a specific location' do
    location = create :location
    hunt = create :hunt, location: location
    expect(location.pending_hunts).to include(hunt)
  end
end
