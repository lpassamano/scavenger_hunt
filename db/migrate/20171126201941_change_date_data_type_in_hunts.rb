class ChangeDateDataTypeInHunts < ActiveRecord::Migration[5.1]
  def change
    remove_column :hunts, :date
    add_column :hunts, :date, :date
  end
end
