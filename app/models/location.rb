class Location < ActiveRecord::Base
  has_many :hunts

  validates :city, presence: true
  validates :state, presence: true 
end
