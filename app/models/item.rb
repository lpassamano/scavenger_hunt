# Class for items to be found during the hunt
class Item < ApplicationRecord
  validates :name, presence: true

  belongs_to :hunt
  delegate :owner, to: :hunt
  has_many :found_items, dependent: :destroy

  after_create :add_found_items

  def add_found_items
    # for each team of the hunt the item belongs to add a found_item to relate
    # the item with each team to track if the team finds the item
    return false unless hunt.teams.count > 0
    hunt.teams.each do |team|
      team.found_items << found_items.build
    end
  end
end
