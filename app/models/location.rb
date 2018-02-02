# Class for hunt location and user location
class Location < ApplicationRecord
  validates :city, presence: true
  validates :state, presence: true
  # uses city-state gem to validate that city entered is in state entered
  # if the city is not in the state it is not saved to DB and an error is given
  validates :city, inclusion: {
    in: proc { |a| CS.get(:US, a.state.to_s) },
    message: 'Ooops! It looks like that city is not in the state you entered!
    Please try again.'
  }

  has_many :hunts
  has_many :users

  def pending_hunts
    # shows all pending hunts in the location
    hunts.where('start_time > ?', DateTime.current)
  end

  def city_state
    "#{city}, #{state}"
  end
end
