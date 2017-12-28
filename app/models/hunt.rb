class Hunt < ActiveRecord::Base
  validates :name, presence: true
  validates :location, presence: true
  validates_associated :location, :message => "- please use the state abbreviation and the city must be in the US state entered."
  validates :meeting_place, presence: true
  validates :start_time, presence: true
  validates :finish_time, presence: true
  validates_datetime :finish_time, :after => :start_time
  validates_datetime :start_time, :after => DateTime.current#, on: :create ## need to uncomment if I have to re-seed the DB

  belongs_to :owner, class_name: "User", foreign_key: "user_id"
  has_many :items
  has_many :teams
  has_many :participants, through: :teams
  belongs_to :location

  accepts_nested_attributes_for :items, :reject_if => lambda {|a| a[:name].blank?}, allow_destroy: true
  include AcceptsNestedAttributesForLocation::InstanceMethods

  ## User Attribute Setter ##
  # def update_current_team(hunt_status)
  #   #update to remove dependency on status attribute
  #   # have it take in no arguments and if self.active? then...
  #   self.teams.each do |team|
  #     team.participants.each do |participant|
  #       if hunt_status == "active"
  #         participant.current_team = team
  #         participant.save
  #       else
  #         participant.current_team = nil if participant.current_team == team
  #         participant.save
  #       end
  #     end
  #   end
  # end

  def update_current_team
    self.teams.each do |team|
      team.participants.each do |participant|
        if self.active?
          participant.current_team = team
          participant.save
        else
          participant.current_team = nil if participant.current_team == team
          participant.save
        end
      end
    end
  end

  ## Class Methods ##
  def self.pending
    self.where("start_time > ?", DateTime.current)
  end

  def self.active
    self.where("start_time <= ?", DateTime.current).where("finish_time >= ?", DateTime.current)
  end

  def self.completed
    self.where("finish_time < ?", DateTime.current)
  end

  def self.update_status
    #delete this when all dependencies on it are changed
    self.all.each do |hunt|
      hunt.status
      hunt.save
    end
  end

  def self.pending_in(location)
    self.pending.where(location: location)
  end

  def self.top_five
    list = self.pending.sort {|x, y| y.participants.count <=> x.participants.count}
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
    self.start_time > DateTime.current
  end

  def upcoming?
    DateTime.current >= (self.start_time.to_time - 48.hours).to_datetime
  end

  def active?
    self.start_time <= DateTime.current && self.finish_time >= DateTime.current
  end

  def completed?
    self.finish_time < DateTime.current
  end

  def status
  # refactor to return status as a string and and updating the current_team for all hunt participants
    if self.pending?
      self.status = "pending"
    elsif self.active?
      self.update_current_team
      self.status = "active"
    elsif self.completed?
      self.update_current_team
      self.status = "completed"
    end
  end

  def leaderboard
    self.teams.sort {|x, y| y.found_items.where(found: true).count <=> x.found_items.where(found: true).count}
  end
end
