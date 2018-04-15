# Class for users
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  validates :email, uniqueness: true
  validates :name, uniqueness: true

  # location validates that the city entered is in the state entered
  # if city is not in state it is not saved to DB and gives an error message
  validates_associated :location, message: '- please use the state
  abbreviation and the city must be in the US state entered.'

  has_many :owned_hunts, class_name: 'Hunt'
  has_many :items, through: :owned_hunts
  has_many :team_participants
  has_many :teams, through: :team_participants
  has_many :comments

  # allows user to be valid even if doesn't have a current team or location
  belongs_to :current_team, class_name: 'Team', required: false
  belongs_to :location, required: false

  accepts_nested_attributes_for :comments
  include AcceptsNestedAttributesForLocation::InstanceMethods

  def self.from_omniauth(auth)
    # handles login or account creation from FB login
    where(uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def team(hunt)
    # given a hunt, returns what team the user is on for that hunt
    teams.where(hunt_id: hunt.id).first
  end

  def all_upcoming_hunts
    # returns all upcoming hunts user is participating in sorted by start date
    hunts = (upcoming_participating_hunts << upcoming_owned_hunts).flatten.compact
    hunts.sort! { |y, z| y.start_time <=> z.start_time }.uniq
  end

  def upcoming_participating_hunts
    # returns all pending hunts that the user is participating in
    hunts = teams.collect do |team|
      team.hunt if team.status == 'pending'
    end
    hunts.compact
  end

  def upcoming_owned_hunts
    # returns all pending hunts that the user created
    hunts = owned_hunts.collect do |hunt|
      hunts << hunt if hunt.pending?
    end
    hunts.compact
  end

  def active_hunt
    # returns hunt if user is participating in a hunt that is active
    # if no active hunt returns nil
    team = teams.find { |t| t.status == 'active' }
    team.hunt unless team.nil?
  end
end
