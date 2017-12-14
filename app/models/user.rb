class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  validates :email, uniqueness: true
  validates :name, uniqueness: true
  validates_associated :location, :message => "- please use the state abbreviation and the city must be in the US state entered."

  has_many :owned_hunts, class_name: "Hunt"
  has_many :items, through: :owned_hunts
  has_many :team_participants
  has_many :teams, through: :team_participants
  #has_many :hunts, through: :teams, class_name: "Hunt", foreign_key: "hunt_id"
  belongs_to :current_team, class_name: "Team", required: false
  belongs_to :location, required: false

  include AcceptsNestedAttributesForLocation::InstanceMethods

  def self.from_omniauth(auth)
    self.where(uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def team(hunt)
    self.teams.where(hunt_id: hunt.id).first
  end

  def all_upcoming_hunts
    hunts = (upcoming_participating_hunts << upcoming_owned_hunts).flatten.compact
    hunts.sort! { |y, z| y.start_time <=> z.start_time }.uniq
  end

  def upcoming_participating_hunts
    hunts = self.teams.collect do |team|
      if team.status == "pending"
        team.hunt
      end
    end
    hunts.compact
  end

  def upcoming_owned_hunts
    self.owned_hunts do |hunt|
      if hunt.status == "pending"
        hunt
      end
    end
  end

  def active_hunt
    team = self.teams.find { |team| team.status == "active" }
    team.hunt if !team.nil?
  end
end
