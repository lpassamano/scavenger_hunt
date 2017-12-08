require 'rails_helper'

RSpec.describe Item, type: :model do
  before(:each) do
    @hunt = Hunt.first
    @item = Item.create(hunt: hunt)
  end

  it 'has a hunt' do
    expect(@item.hunt).to eq(Hunt.first)
  end

  it 'has a user' do
    expect(@item.owner).to eq(@item.hunt.owner)
  end

  it 'upon instantiation creates found_items for each team in its hunt' do
    team = @hunt.teams.first
    num_items = team.items.count

    Item.create(hunt: @hunt)
    expect(team.items.count).to eq(num_items + 1)
  end
end
