class AddDefaultValueToHuntStatus < ActiveRecord::Migration[5.1]
  def change
    change_column :hunts, :status, :string, :default => "pending"
  end
end
