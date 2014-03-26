# Geokit for all geographical needs on the server side
require 'geokit'

# A simple class which would give out all the trips around the login location

# USAGE : NearbyTrip.new( 
#                         parameter_in_terms_of_ip_or_lat_lon_or_address, 
#                         amount_of_distance_for_trips 
#                       )
#                       .trips

# TODO :
# 1) Clean up the loop in trips. too many queries as well.
# 2) the current_location method only supports IP addresses as of now. Make it work on all cases

class NearbyTrip

  attr_accessor :param, :curr_loc, :distance

  def initialize( user, parameter, distance=nil )
    @user     = user
    @param    = parameter
    @distance = distance ? distance : 1000 # clean this line
  end

  # gathers an array of nearby trips within a range of given distance
  def trips
    @curr_loc ||= current_location
    nearby_trips = []

    Trip.where('trips.user_id != ? and trips.draft_version = ?', @user.id, false).each do |trip|
      trip.places.each do |place|
        if @curr_loc.distance_to( gather_lat_and_lon(place) ) < @distance
          nearby_trips << trip
          break
        end
      end
    end
    nearby_trips
  end

  # Considering ideal condition that the parameter would be an ip address
  # Fetches the location from the hostip.info api accessible via Geokit itself
  def current_location

    # Creating an instance variable because Geokit itself is going to invoke an external
    # api to fetch the location based on the parameter and that could take time.
    # Also, tomorrow we may introduce several more methods so that would most obviously help
    return ( @curr_loc = Geokit::Geocoders::MultiGeocoder.geocode( @param ) )
  end

  # Format for the lat and lon needed for Geocode to calculate distance between
  # two lat and lon combinations !
  def gather_lat_and_lon( place )
    "#{place["lat"]},#{place["lon"]}"
  end
end