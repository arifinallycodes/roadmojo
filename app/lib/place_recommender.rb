# A place recommender algorigthm
# Author : kaushik thirthappa(kaushik@roadmojo.com)
# 
# Usage :  PlaceRecommender.new( user ).recommend
class PlaceRecommender

  def initialize( user )
    @user = user
  end

  # Using basic set operations with ruby
  def recommend
    ( most_followed_places | user_following_places ) - ( most_followed_places & user_following_places )
    # ( most_followed_places | user_following_places )
  end

  # Displays ten places in descending order with the most no of followers
  def most_followed_places
    # Place.order('following_users_count DESC').limit(10)
    Place.where('following_users_count > ?', 0).order('following_users_count DESC')
  end

  # does the user follow the place ?
  def user_follow_place?( place )
    @user.following_places.find_by_id( place.id )
  end

  # lists all the places user is following
  def user_following_places
    @user.following_places
  end
end