class Team < ActiveRecord::Base
  has_many :team_participants
  has_many :participants, through: :team_participants, source: :user
  belongs_to :hunt
  delegate :status, to: :hunt
  has_many :found_items
  has_many :items, through: :found_items

  scope :pending, -> { where()}

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
