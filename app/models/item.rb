class Item < ActiveRecord::Base
  belongs_to :hunt
  delegate :user, to: :hunt
  has_many :found_items

  validates :name, presence: true 
end
