require 'rails_helper'

RSpec.describe Item, type: :model do
  before(:each) do
    @item = Item.create(hunt: Hunt.first)
  end

  it 'has a hunt' do

  end

  it 'has a user' do
    
  end
end
