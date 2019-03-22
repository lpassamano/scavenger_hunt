require 'rails_helper'

RSpec.describe Team, type: :model do
  it 'has a working factory' do
    team = create :team
    team2 = create :team

    expect(team).to_not eq(team2)
  end
end
