class TeamParticipant < ActiveRecord::Base
  belongs_to :team
  belongs_to :participant, class_name: "User", foreign_key: "user_id"
end
