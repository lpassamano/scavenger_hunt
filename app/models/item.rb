class Item < ActiveRecord::Base
  validates :name, presence: true
  
  belongs_to :hunt
  delegate :owner, to: :hunt
  has_many :found_items, :dependent => :destroy

  after_create :add_found_items

  def add_found_items
    if self.hunt.teams.count > 0
      self.hunt.teams.each do |team|
        team.found_items << self.found_items.build
      end
    end
  end
end
