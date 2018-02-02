# Class for join table to relate a user to a team
class TeamParticipant < ApplicationRecord
  belongs_to :team
  belongs_to :user
end
