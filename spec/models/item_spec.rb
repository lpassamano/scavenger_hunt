require 'rails_helper'

RSpec.describe Item, type: :model do
  it 'has a working factory' do
    item = create :item
    item2 = create :item

    expect(item).to_not eq(item2)
  end

  it 'creates a found_item for each team in its hunt' do
    hunt = create :hunt
    create :team, hunt: hunt

    expect{
      hunt.items.create(name: "New Item")
    }.to change(FoundItem, :count).by(1)
  end
end
