FactoryBot.define do
  factory :user do
    name { Faker::Internet.user_name }
    email { Faker::Internet.email }
    password { "password123" }
  end

  factory :location do
    state { Faker::Address.state_abbr }
    city { CS.get(:US, state).sample }
  end

  factory :hunt do
    association :owner, factory: :user
    location
    name { Faker::Games::Zelda.location }
    start_time { (DateTime.current + rand(1..30).days).to_datetime }
    finish_time { (start_time + 2.hours).to_datetime }
    meeting_place { Faker::Address.street_address }
  end

  factory :hunt_params, class: Hunt do
    association :owner, factory: :user
    name { Faker::Games::Zelda.location }
    start_time { (DateTime.current + rand(1..30).days).to_datetime }
    finish_time { (start_time + 2.hours).to_datetime }
    meeting_place { Faker::Address.street_address }
    location_attributes { attributes_for :location }
  end

  factory :active_hunt, class: Hunt do
    association :owner, factory: :user
    location
    name { Faker::Games::Zelda.location }
    start_time { DateTime.current }
    finish_time { (start_time + 2.hours).to_datetime }
    meeting_place { Faker::Address.street_address }
  end

  factory :completed_hunt, class: Hunt do
    association :owner, factory: :user
    location
    name { Faker::Games::Zelda.location }
    start_time { DateTime.current }
    finish_time { DateTime.current }
    meeting_place { Faker::Address.street_address }
  end

  factory :item do
    hunt
    name { Faker::Games::Zelda.item }
  end

  factory :team do
    hunt
  end
end
