class Location < ActiveRecord::Base
  has_many :hunts

  validates :city, presence: true
  validates :state, presence: true
  validates :city, inclusion: { in: Proc.new { |a| CS.get(:US, a.state.to_s)} }
end
