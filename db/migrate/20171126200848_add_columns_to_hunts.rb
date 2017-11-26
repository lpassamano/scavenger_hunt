class AddColumnsToHunts < ActiveRecord::Migration[5.1]
  def change
    add_column :hunts, :start_time, :time
    add_column :hunts, :finish_time, :time
    remove_column :hunts, :duration
  end
end
