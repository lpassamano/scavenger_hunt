class Hunt < ActiveRecord::Base
  belongs_to :owner, class_name: "User", foreign_key: "user_id"
  has_many :items
  has_many :teams
  belongs_to :location

  validates :name, presence: true
  validates :location, presence: true
  validates :start_time, presence: true
  validates :finish_time, presence: true
  validates_datetime :finish_time, :after => :start_time
  validates_datetime :start_time, :after => DateTime.current

  ## Attribute Setter Methods ##
  def status
    if DateTime.current < self.start_time
      "pending"
    elsif DateTime.current >= self.start_time && DateTime.current <= self.finish_time
      "active"
    elsif DateTime.current > self.finish_time
      "completed"
    end
  end

  ## Class Methods ##
  def self.all_pending
    self.where(status: "pending")
  end

  def self.all_active
    self.where(status: "active")
  end

  def self.all_completed
    self.where(status: "completed")
  end

  def self.top_five
    list = self.all.sort {|x, y| y.participants_count <=> x.participants_count}
    list[0, 5]
  end

  ## Instance Methods ##
  def date
    self.start_time.strftime("%A, %B%e, %Y")
  end

  def pending?
    self.status == "pending"
  end

  def upcoming?
    DateTime.current >= (self.start_time.to_time - 48.hours).to_datetime
  end

  def participants_count
    count = 0
    self.teams.each do |team|
      count += team.participants_count
    end
    count
  end
end
