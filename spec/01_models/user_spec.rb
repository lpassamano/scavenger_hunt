require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a working factory' do
    user = create :user
    user2 = create :user

    expect(user).to_not eq(user2)
  end
end
