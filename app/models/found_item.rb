# Class for join table between team and item and tracks if team has found item
class FoundItem < ApplicationRecord
  belongs_to :item
  belongs_to :team
end
