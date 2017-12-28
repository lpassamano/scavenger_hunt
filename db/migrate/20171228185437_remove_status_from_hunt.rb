class RemoveStatusFromHunt < ActiveRecord::Migration[5.1]
  def change
    remove_column :hunts, :status
  end
end
