class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :hunts
  has_many :items, through: :hunts
  has_many :team_participants
  has_many :teams, through: :team_participants
  belongs_to :current_team, class_name: "Team", required: false
end
