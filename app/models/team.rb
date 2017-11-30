class Team < ActiveRecord::Base
  has_many :team_participants
  has_many :participants, through: :team_participants, class_name: 'User', foreign_key: 'user_id'
  belongs_to :hunt
  has_many :found_items

  def name
    read_attribute(:name) || "Team #{self.id}"
  end

  def missing_items
    self.found_items.where(found: false)
  end

  def participants_count
    self.participants.count
  end
end
