class Item < ActiveRecord::Base
  belongs_to :hunt
  delegate :user, to: :hunt 
end
