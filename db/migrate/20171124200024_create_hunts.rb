class CreateHunts < ActiveRecord::Migration[5.1]
  def change
    create_table :hunts do |t|
      t.string :name
      t.datetime :date
      t.integer :duration
      t.string :status
      t.integer :location_id
      t.integer :user_id
    end
  end
end
