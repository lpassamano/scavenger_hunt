class AddMeetingPlaceToHunts < ActiveRecord::Migration[5.1]
  def change
    add_column :hunts, :meeting_place, :string
  end
end
