require 'rails_helper'

RSpec.describe Item, type: :model do
  it 'has a working factory' do
    item = create :item
    item2 = create :item

    expect(item).to_not eq(item2)
  end

  it 'upon instantiation creates found_items for each team in its hunt' do
    team = @hunt.teams.first
    num_items = team.items.count

    @hunt.items.build(name: "New Item")
    @hunt.save
    expect(team.items.count).to eq(num_items + 1)
  end
end
