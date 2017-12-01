class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, uniqueness: true
  validates :name, uniqueness: true

  has_many :hunts
  has_many :items, through: :hunts
  has_many :team_participants
  has_many :teams, through: :team_participants
  has_many :participating_hunts, through: :teams, class_name: "Hunt", foreign_key: "hunt_id"
  belongs_to :current_team, class_name: "Team", required: false
  belongs_to :location, required: false

  def team(hunt)
    self.teams.where(hunt_id: hunt.id).first
  end

  def upcoming_hunts
    self.hunts
    self.teams.collect do |team|
      if team.status == "pending"
        team.hunt
      end
    end
  end
end
