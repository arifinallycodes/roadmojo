# A class to manage the following the places feature for the user !
# 
# USAGE : UserFollow.new(current_user, array_of_hash_of_places_to_follow_or_nil, place_instance_or_nil).follow
# 
# TODO :
#   1) think over follow_given_place method.

class UserFollow

  attr_accessor :user, :places_hash

  def initialize( user, places_hash=nil, place=nil )
    @user        = user
    @places_hash = places_hash
    @place       = place
  end

  # Follow instance method !
  def follow
    if @places_hash.empty? or @places_hash.blank? or @places_hash.nil?
      follow_given_place
    else
      validate_and_follow
    end
    return @followed_trip_places.nil? ? false : true
  end

  def trips
    place_ids = @user.ids_of_following_places
    # using a collect here to pass in an array in the query below it. Else i would have used .select
    trip_ids  = TripPlace.where('trip_places.place_id in (?)', place_ids).collect { |trip_place| trip_place.trip_id }
    Trip.where( 'id in (?) and user_id != ? and draft_version = ?', trip_ids, @user.id, false ).order( 'updated_at DESC' )
  end

  # change the loop here
  # get all the trips with all the lat and lon combination in one query and then store it in an array
  # then loop to find which ones already exists in teh db from teh array itself and not teh db
  # if not in the array, then create one and follow or just follow !
  def validate_and_follow
    @places_hash.each do |hash|
      find_or_create_and_add_places( hash )
    end
  end

  def find_or_create_and_add_places( place )
    if ( existing_place = Place.find_by_lat_and_lon( place["lat"], place["lon"] ) )
      if !@user.following_places.find_by_id( existing_place.id )
        @followed_trip_places = existing_place
        @user.following_places << @followed_trip_places
        update_count_of_follow
      end
    else
      @followed_trip_places = Place.create!( lat: place["lat"], lon: place["lon"], name: place["name"] )
      @user.following_places << @followed_trip_places
      update_count_of_follow
    end
  end

  def update_count_of_follow
    # MetaRoad.increment_count( @user, "following_places_count" ) 
    # Turns out rails is shooting the below query automatically...or not. i am not sure but the count is being increaased by 2. Thus
    # i am commenting the above line. Will figure out how in the future stage and then uncomment
    # SQL (0.3ms)  UPDATE "users" SET "following_places_count" = COALESCE("following_places_count", 0) + 1 WHERE "users"."id" = 1
    MetaRoad.increment_count( @followed_trip_places, "following_users_count" )
  end

  # def increment_count( model_instance, association )
  #   inst = eval(model_instance)
  #   column_name = "following_#{association}_count"
  #   count = inst.send(column_name)
  #   inst.update_column( column_name, count + 1 )
  # end

  # This method is used if the user has instructed to follow only one place.
  # THink over this method again.
  def follow_given_place
    @user.following_places << @place
    @followed_trip_places = @place
    update_count_of_follow
  end
end