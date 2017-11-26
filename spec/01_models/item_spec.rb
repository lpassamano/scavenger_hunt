require 'rails_helper'

RSpec.describe Item, type: :model do
  before(:each) do
    @item = Item.new(hunt: Hunt.create)
  end

  it 'has a hunt' do
    expect(@item.hunt).to eq(Hunt.last)
  end

  it 'has a user' do
    expect(@item.user).to eq(@item.hunt.user)
  end
end
