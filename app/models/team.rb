# Class for teams
class Team < ApplicationRecord
  has_many :team_participants
  has_many :participants, through: :team_participants, source: :user
  belongs_to :hunt
  has_many :found_items, dependent: :destroy
  has_many :items, through: :found_items

  after_create :add_found_items

  def name
    # if no name is provided, defaults to using the team's id - ie: "Team 3"
    @name = "Team #{id}" if read_attribute(:name) == ''
    read_attribute(:name) || @name = "Team #{id}"
  end

  def status
    hunt.status
  end

  def participants_count
    participants.count
  end

  def found_items_count
    # returns number of items found by team
    found_items.where(found: true).count
  end

  def add_participant(user)
    # adds user to the team
    if user.teams.where(hunt: hunt) == []
      participants << user
    else
      false
    end
  end

  def add_found_items
    # for each item in the hunt the team belongs to add a found_item to relate
    # the team with each item to track which items the team finds
    return false unless hunt.items.count > 0
    hunt.items.each do |item|
      found_items << item.found_items.build
    end
  end
end
