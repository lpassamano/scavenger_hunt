class Team < ActiveRecord::Base
  has_many :team_participants
  has_many :participants, through: :team_participants, class_name: 'User', foreign_key: 'user_id'
  belongs_to :hunt
  has_many :found_items 
end
