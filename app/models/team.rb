class Team < ActiveRecord::Base
  has_many :team_participants
  has_many :participants, through: :team_participants, source: :user
  belongs_to :hunt
  delegate :status, to: :hunt
  has_many :found_items, :dependent => :destroy
  has_many :items, through: :found_items

  scope :pending, -> { where()}

  after_create :add_found_items

  def name
    self.name = "Team #{self.id}" if self.name = ""
    read_attribute(:name) || self.name = "Team #{self.id}"
  end

  def missing_items
    self.found_items.where(found: false)
  end

  def participants_count
    self.participants.count
  end

  def add_participant(user)
    if user.teams.where(hunt: self.hunt) == []
      self.participants << user
    else
      false
    end
  end

  def add_found_items
    if self.hunt.items.count > 0
      self.hunt.items.each do |item|
        self.found_items << item.found_items.build
      end
    end
  end
end
