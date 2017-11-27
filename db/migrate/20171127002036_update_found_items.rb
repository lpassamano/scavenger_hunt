class UpdateFoundItems < ActiveRecord::Migration[5.1]
  def change
    change_column :found_items, :found, :boolean, :default => false
  end
end
