require 'rails_helper'

RSpec.describe Item, type: :model do
  before(:each) do
    hunt = Hunt.first
    @item = Item.create(hunt: hunt)
  end

  it 'has a hunt' do
    expect(@item.hunt).to eq(Hunt.first)
  end

  it 'has a user' do
    expect(@item.owner).to eq(@item.hunt.owner)
  end
end
