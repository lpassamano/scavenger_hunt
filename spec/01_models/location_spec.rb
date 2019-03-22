require 'rails_helper'

RSpec.describe Location, type: :model do
  it 'has a working factory' do
    location = create :location
    location2 = create :location

    expect(location).to_not eq(location2)
  end
end
