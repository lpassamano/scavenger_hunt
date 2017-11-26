class Hunt < ActiveRecord::Base
  belongs_to :user
  has_many :items
  has_many :teams
  belongs_to :location

  def self.pending
    Hunt.where(status: "pending")
  end

  def self.active
    Hunt.where(status: "active")
  end

  def self.completed
    Hunt.where(status: "completed")
  end
end
