class Location < ActiveRecord::Base
  has_many :hunts

  validates :city, presence: true
  validates :state, presence: true
  validates :state, format: { with: /b[A-Z]{2}\b/i, message: "Please type enter the state's abbreviation" }
end
