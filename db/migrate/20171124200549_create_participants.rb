class CreateParticipants < ActiveRecord::Migration[5.1]
  def change
    create_table :participants do |t|
      t.integer :user_id
      t.integer :team_id
    end
  end
end
