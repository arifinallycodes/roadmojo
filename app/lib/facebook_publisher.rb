# A simple class to generate you the url to post on facebook using its dialog feed
# which is very efficient for the users to control all of their possible settings while
# sharing a trip.

# USAGE : FacebookPublisher.new( request, trip ).url

# TODO : 
# 1) Find a way to load the devise module to use the current_user method instead of shooting a sql query
#    while initializing. Basically, i am talkin' about the second line on the initialize method. 
# 2) There are other query paramters that can be added such as photo, description etc.
#    visit https://developers.facebook.com/docs/reference/dialogs/feed/ for more details.

class FacebookPublisher

  # This module has been included to use the trip_path. Notice the path ?
  include Rails.application.routes.url_helpers

  # To initialize, send the request object along with the trip from your view or controller here. 
  # The request object would have all of your request details such as protocol (could be http or https among others)
  def initialize( request, trip )
    @trip           = trip
    @trip_owner     = @trip.user 
    @protocol       = request.protocol
    @host_with_port = request.host_with_port
  end

  # Returns the consolidated url
  def url
    "#{fb_post_url + query_parameters}"
  end

  # This is the base url without any query paramters for Facebook
  def fb_post_url
    "https://www.facebook.com/dialog/feed?"
  end

  # Gather all of your query paramters for the facebook url
  def query_parameters
    link_to_share = "#{@protocol + @host_with_port + trip_path( @trip_owner, @trip)}"
    "app_id=#{ FACEBOOK_APP_ID }&link=#{ URI.escape( link_to_share ) }&name=#{ URI.escape( @trip.name ) }&caption=#{ URI.escape( @trip.description.slice(0,150) ) }&display=popup&redirect_uri=#{ URI.escape( link_to_share ) }"
  end
end