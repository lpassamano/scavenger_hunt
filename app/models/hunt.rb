class Hunt < ActiveRecord::Base
  belongs_to :user
  has_many :items
  has_many :teams
  belongs_to :location

  validates :name, presence: true
  validates :location, presence: true
  validates :start_time, presence: true
  validates :finish_time, presence: true
  validates_datetime :finish_time, :after => :start_time
  validates_datetime :start_time, :after => DateTime.current

  def status
    if DateTime.current < self.start_time
      "pending"
    elsif DateTime.current >= self.start_time && DateTime.current <= self.finish_time
      "active"
    elsif DateTime.current > self.finish_time
      "completed"
    end
  end

  def self.pending
    Hunt.where(status: "pending")
  end

  def self.active
    Hunt.where(status: "active")
  end

  def self.completed
    Hunt.where(status: "completed")
  end

  def date
    self.start_time.strftime("%A, %B%e, %Y")
  end
end
