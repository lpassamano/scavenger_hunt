class Team < ActiveRecord::Base
  has_many :team_participants
  has_many :participants, through: :team_participants, source: :user
  belongs_to :hunt
  has_many :found_items, :dependent => :destroy
  has_many :items, through: :found_items

  after_create :add_found_items

  def name
    @name = "Team #{self.id}" if read_attribute(:name) == ""
    read_attribute(:name) || @name = "Team #{self.id}"
  end

  def status
    self.hunt.status
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
