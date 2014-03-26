# Temp
# add computations if you wanna invoke it from seeds.rb file.
# these class methods would be invoked when rake db:seed is run

class Seed

  def self.compute_likes_for_trips
    puts "computing likes for trips !!"
    trips = Trip.all
    trips.each do |trip|
      trip.no_of_likes = trip.users_liking_it.count
      trip.save!
    end
  end

  def self.compute_likes_for_users
    puts "computing likes for Users !!"
    users = User.all
    users.each do |user|
      user.no_of_likes = user.liked_trips.count
      user.save!
    end
  end
end