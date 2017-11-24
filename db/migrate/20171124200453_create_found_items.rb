class CreateFoundItems < ActiveRecord::Migration[5.1]
  def change
    create_table :found_items do |t|
      t.boolean :found
      t.iteger :team_id
      t.integer :item_id
    end
  end
end
