class UsersLikedTrip < ActiveRecord::Base
  belongs_to :user
  belongs_to :trip
  # attr_accessible :title, :body
end
