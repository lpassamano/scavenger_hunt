require 'rails_helper'

RSpec.describe Hunt, type: :model do
  it 'has a working factory' do
    hunt = create :hunt
    hunt2 = create :hunt

    expect(hunt).to_not eq(hunt2)
  end

  it 'has a default status of pending' do
    hunt = create :hunt
    expect(hunt.status).to eq("pending")
  end

  it 'has a method to display all pending hunts' do
    count = Hunt.pending.count
    pending_hunt = create :hunt
    expect(Hunt.pending.count).to eq(count + 1)
    expect(Hunt.pending).to include(pending_hunt)
  end

  it 'has a method to display all active hunts' do
    count = Hunt.active.count
    active_hunt = create :active_hunt
    expect(Hunt.active.count).to eq(count + 1)
    expect(Hunt.active).to include(active_hunt)
  end

  it 'has a method to display all completed hunts' do
    count = Hunt.completed.count
    completed_hunt = create :completed_hunt
    expect(Hunt.completed.count).to eq(count + 1)
    expect(Hunt.completed).to include(completed_hunt)
  end

  it 'is invalid if the end time is before the start time' do
    hunt = build :hunt,
      finish_time: DateTime.new(2028, 1, 1, 12, 00, 00),
      start_time: DateTime.new(2028, 1, 1, 15, 00, 00)

    expect(hunt).to_not be_valid
  end

  it 'is invalid with a date in the past' do
    hunt = build :hunt,
      start_time: DateTime.new(2016, 1, 1, 12, 00, 00),
      finish_time: DateTime.new(2016, 1, 1, 15, 00, 00)

    expect(hunt).to_not be_valid
  end

  it 'updates the status to active at start time' do
    hunt = create :hunt, start_time: DateTime.current
    expect(hunt.status).to eq("active")
  end

  it 'updates the status to completed at end time' do
    hunt = create :hunt, start_time: DateTime. current, finish_time: DateTime.current
    expect(hunt.status).to eq("completed")
  end

  it 'has a method to display the date' do
    hunt = create :hunt, start_time: DateTime.new(2028, 1, 1, 12, 00, 00)
    expect(hunt.date).to eq("Sat, January 1 at 12:00pm - 2:00pm")
  end
end
