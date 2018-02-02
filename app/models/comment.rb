# Class for individual comments by a user on a hunt show page
# Temporarily removed Commenting due to bug -- see notes.md
class Comment < ApplicationRecord
  validates :text, presence: true

  belongs_to :user
  belongs_to :hunt
end
