require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create :user }

  let(:valid_params) do
    {
      name: 'Leigh',
      location_attributes: {
        city: 'Philadelphia',
        state: 'PA'
      }
    }
  end

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

  it "updates with valid params" do
    user.update(valid_params)
    expect(user.name).to eq("Leigh")
  end
end
