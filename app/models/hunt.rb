# Class for scavenger hunts
class Hunt < ApplicationRecord
  validates :name, presence: true
  validates :location, presence: true
  validates_associated :location, message: '- please use the state
  abbreviation and the city must be in the US state entered.'
  validates :meeting_place, presence: true
  validates :start_time, presence: true
  validates :finish_time, presence: true
  validates_datetime :finish_time, after: :start_time
  validates_datetime :start_time, after: DateTime.current # , on: :create
  ## need to uncomment above if DB need to be re-seeded

  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  has_many :items
  has_many :teams
  has_many :participants, through: :teams
  belongs_to :location
  has_many :comments

  accepts_nested_attributes_for :items,
                                reject_if: ->(a) { a[:name].blank? },
                                allow_destroy: true
  accepts_nested_attributes_for :comments
  include AcceptsNestedAttributesForLocation::InstanceMethods

  ## Class methods that return all hunts of each status ##
  def self.pending
    where('start_time > ?', DateTime.current)
  end

  def self.active
    where('start_time <= ?', DateTime.current).where('finish_time >= ?', DateTime.current)
  end

  def self.completed
    where('finish_time < ?', DateTime.current)
  end

  ## Other class methods ##
  def self.pending_in(location)
    pending.where(location: location)
  end

  def self.top_five
    # returns the 5 hunts that have the most participants
    list = pending.sort { |x, y| y.participants.count <=> x.participants.count }
    list[0, 5]
  end

  ## Instance methods that give hunt details ##
  def status
    # updates the current team of all users participating in the hunt
    # then updates the hunt's status
    update_current_team
    if pending?
      'pending'
    elsif active?
      'active'
    elsif completed?
      'completed'
    end
  end

  def leaderboard
    # sorts teams by number of items found
    teams.sort { |x, y| y.found_items_count <=> x.found_items_count }
  end

  def date
    # displays the hunt's start and finish times as Sat, December 2 at 12pm
    if same_start_finish_date?
      display_start_date + display_finish_time
    else
      display_start_date + display_finish_date
    end
  end

  def display_start_date
    # displays the start time as Sat, Dec 2 at 12pm
    start_time.strftime('%a, %B %-e at %-I:%M') + start_time.strftime('%p').downcase
  end

  def display_finish_time
    # displays the finish time as 3:30pm
    " - #{(finish_time.strftime('%-I:%M') + finish_time.strftime('%p').downcase)}"
  end

  def display_finish_date
    # displays finish date and time as Sun, Dec 3 at 12pm
    " - #{(finish_time.strftime('%a, %B %-e at %-I:%M') + finish_time.strftime('%p').downcase)}"
  end

  def same_start_finish_date?
    start_time.strftime('%m%d%Y') == finish_time.strftime('%m%d%Y')
  end

  ## Instance methods that check status of hunt ##
  def pending?
    # true if current date/time is before the hunt start time
    start_time > DateTime.current
  end

  def upcoming?
    # true if start time is in 2 days/48 hours or less
    DateTime.current >= (start_time.to_time - 48.hours).to_datetime
  end

  def active?
    # true if current date/time is between the hunt start and finish times
    start_time <= DateTime.current && finish_time >= DateTime.current
  end

  def completed?
    # true if current date/time is after hunt finish time
    finish_time < DateTime.current
  end

  ## Sets user attributes ##
  def update_current_team
    # updates the current team of all users participating in the hunt
    teams.each do |team|
      team.participants.each do |participant|
        if active?
          # if hunt is active participants current team is updated to their
          # team for this hunt
          participant.current_team = team
          participant.save
        elsif participant.current_team == team
          # if hunt is not active the current team is changed to nil
          # only if their current team was a team for this hunt
          participant.current_team = nil
          participant.save
        end
      end
    end
  end
end
