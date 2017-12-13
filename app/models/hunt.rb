class Hunt < ActiveRecord::Base
  belongs_to :owner, class_name: "User", foreign_key: "user_id"
  has_many :items
  has_many :teams
  has_many :participants, through: :teams
  belongs_to :location

  validates :name, presence: true
  validates :location, presence: true
  validates_associated :location, :message => "can't be blank"
  validates :start_time, presence: true
  validates :finish_time, presence: true
  validates_datetime :finish_time, :after => :start_time
  validates_datetime :start_time, :after => DateTime.current#, on: :create ## may need to uncomment if I have to re-seed the DB

  accepts_nested_attributes_for :items, :reject_if => lambda {|a| a[:name].blank?}, allow_destroy: true

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

  def update_current_team(hunt_status)
    self.teams.each do |team|
      team.participants.each do |participant|
        if hunt_status == "active"
          participant.current_team = team
          participant.save
        else
          participant.current_team = nil if participant.current_team == team
          participant.save
        end
      end
    end
  end

  def location_attributes=(new_location)
    existing_location = Location.find_by(city: new_location[:city])
    if existing_location && existing_location.state == new_location[:state]
      self.location = existing_location
    else
      self.location = Location.create(city: new_location[:city], state: new_location[:state])
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

  def self.top_five
    list = self.all.sort {|x, y| y.participants.count <=> x.participants.count}
    list[0, 5]
  end

  ## Instance Methods ##
  def date
    # display as Sat, December 2 at 12pm
    if start_time.strftime("%m%d%Y") == finish_time.strftime("%m%d%Y")
      finish = (finish_time.strftime("%-I:%M") + finish_time.strftime("%p").downcase)
    else
      finish = (finish_time.strftime("%a, %B %-e at %-I:%M") + finish_time.strftime("%p").downcase)
    end
    start_time.strftime("%a, %B %-e at %-I:%M") + start_time.strftime("%p").downcase + " - " + finish
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

  def completed?
    self.status == "completed"
  end

  def leaderboard
    self.teams.sort {|x, y| y.found_items.where(found: true).count <=> x.found_items.where(found: true).count}
  end
end
