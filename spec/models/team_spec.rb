require 'rails_helper'

RSpec.describe Team, type: :model do
  it 'has a working factory' do
    team = create :team
    team2 = create :team

    expect(team).to_not eq(team2)
  end

  it 'will generate a name if one is not given at initialization' do
    team = create :team
    expect(team.name).to eq("Team #{team.id}")
  end

  it 'creates a found_item for each item in its hunt' do
    hunt = create :hunt
    create :item, hunt: hunt

    expect{
      hunt.teams.create(name: "A Team")
    }.to change(FoundItem, :count).by(1)
  end
end
