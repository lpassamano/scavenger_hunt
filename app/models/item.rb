class Item < ActiveRecord::Base
  belongs_to :hunt
  delegate :owner, to: :hunt
  has_many :found_items

  validates :name, presence: true
end
