class Hunt < ActiveRecord::Base
  belongs_to :user
  has_many :items
  has_many :teams
  belongs_to :location
end
