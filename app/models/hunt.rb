class Hunt < ActiveRecord::Base
  belongs_to :owner, class_name: "User", foreign_key: "user_id"
  has_many :items
  has_many :teams
  has_many :participants, through: :teams
  belongs_to :location

  validates :name, presence: true
  validates :location, presence: true
  validates :start_time, presence: true
  validates :finish_time, presence: true
  validates_datetime :finish_time, :after => :start_time
  validates_datetime :start_time, :after => DateTime.current, on: :create

  ## Attribute Setter Methods ##
  def status
    if DateTime.current < self.start_time
      self.status = "pending"
    elsif DateTime.current >= self.start_time && DateTime.current <= self.finish_time
      self.update_current_team("active")
      self.status = "active"
    elsif DateTime.current > self.finish_time
      self.update_current_team("completed")
      self.status = "completed"
    end
  end

  def update_current_team(status)
    self.teams.each do |team|
      team.participants.each do |participant|
        if status == "active"
          participant.current_team = team
        else
          participant.current_team = nil if participant.current_team == team
        end
      end
    end
  end

  ## Class Methods ##
  def self.pending
    self.update_status
    self.where(status: "pending").sort{|x, y| x.start_time <=> y.start_time}
  end

  def self.active
    self.update_status
    self.where(status: "active")
  end

  def self.completed
    self.update_status
    self.where(status: "completed")
  end

  def self.update_status
    self.all.each do |hunt|
      hunt.status
      hunt.save
    end
  end

  def self.pending_in(location)
    self.update_status
    self.where(location: location).where(status: "pending")
  end

  def self.upcoming_for(user)
    #see if this can happen

    #SELECT * FROM hunts
    #  JOIN teams ON teams.hunt_id = hunts.id
    #  JOIN team_participants ON team_participants.team_id = team.id
    #  JOIN users ON users.id = team_participants.user_id
    #WHERE
    #  hunt.status = "pending"

    #self.joins(teams: {team_participants: :user}).where(user: {user_id: user.id}, hunt: {status: "pending"})
  end

  def self.top_five
    list = self.all.sort {|x, y| y.participants.count <=> x.participants.count}
    list[0, 5]
  end

  ## Instance Methods ##
  def date
    # display as Sat, December 2 at 12pm
    start = self.start_time
    start_str = (start.strftime("%a, %B %-e at %-I:%M") + start.strftime("%p").downcase)
    #self.start_time.strftime("%a, %B%e at %m:%M %p")
  end

  def pending?
    self.status == "pending"
  end

  def upcoming?
    DateTime.current >= (self.start_time.to_time - 48.hours).to_datetime
  end

  def active?
    self.status == "active"
  end

  def leaderboard
    self.teams.sort {|x, y| y.found_items.count <=> x.found_items.count}
  end
end
