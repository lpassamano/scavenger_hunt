class Location < ActiveRecord::Base
  has_many :hunts

  validates :city, presence: true
  validates :state, presence: true
  validates :city, inclusion: { in: Proc.new { |a| CS.get(:US, a.state.to_s)}, message: "Ooops! It looks like that city is not in the state you entered! Please try again." }

  def pending_hunts
    self.hunts.where(status: "pending")
  end
end
