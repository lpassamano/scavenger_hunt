require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a working factory' do
    user = create :user
    user2 = create :user

    expect(user).to_not eq(user2)
  end

  it 'has a unique email' do
    create :user, email: 'email@example.com'
    user2 = build :user, email: 'email@example.com'
    expect(user2).to_not be_valid
  end

  it 'has a unique username' do
    create :user, name: 'leigh_p'
    user2 = build :user, name: 'leigh_p'
    expect(user2).to_not be_valid
  end
end
