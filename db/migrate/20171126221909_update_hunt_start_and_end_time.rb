class UpdateHuntStartAndEndTime < ActiveRecord::Migration[5.1]
  def change
    remove_column :hunts, :date
    remove_column :hunts, :start_time
    remove_column :hunts, :finish_time
    add_column :hunts, :start_time, :datetime
    add_column :hunts, :finish_time, :datetime
  end
end
