class Location < ActiveRecord::Base
  validates :city, presence: true
  validates :state, presence: true
  validates :city, inclusion: { in: Proc.new { |a| CS.get(:US, a.state.to_s)}, message: "Ooops! It looks like that city is not in the state you entered! Please try again." }

  has_many :hunts
  has_many :users

  def pending_hunts
    self.hunts.where(status: "pending")
  end

  def city_state
    "#{self.city}, #{self.state}"
  end
end
