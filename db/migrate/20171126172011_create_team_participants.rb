class CreateTeamParticipants < ActiveRecord::Migration[5.1]
  def change
    create_table :team_participants do |t|
      t.integer :user_id
      t.integer :team_id
    end
  end
end
