class FollowsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_user_by_username
  before_filter :set_skip_and_continue

  layout Proc.new { |controller| controller.request.xhr? ? false : 'application' }

  respond_to :html, :json, :js

  def index
    @items  = []
    @places = []
    @follow_places = []
    @following_places = @user.ordered_places_following
    @recommended_places = PlaceRecommender.new( current_user ).recommend.first(15)
    @draft_trips = @user.trips.where('draft_version=?',true).limit(2).order('created_at DESC')
    if params[:ref] == 'sign_up'
      @display_help_message = true
      empty_flash
      flash[:notice] = "Please follow your favorite places to get started with Roadmojo !"
    end
  end

  # GET /:username/follow
  def new
    @places = []
    @items = []
    @follow_places = []
  end

  # POST /:username/follow/add
  def add_places
    begin
      if params.has_key?(:trip)
        places = params[:trip][:places]
        if ( @follow = UserFollow.new( current_user, places ).follow )
          respond_to_request( true, "Successfully followed #{places.first[:name]}" )
          # respond_to_request( true, "Successfully followed places" )
        else
          respond_to_request( false, "You cannot follow places that you are already following" )
        end
      elsif params.has_key?(:follow_place_id)
        if ( place = Place.find_by_id( params[:follow_place_id] ) )
          place = Place.find_by_id( params[:follow_place_id] )
          if ( @follow = UserFollow.new( current_user, [], place ).follow )
            flash[:notice] = "Successfully followed #{place.name}"
            redirect_to all_following_places_path(username: current_user.username)
          else
            flash[:alert] = "Could not follow #{place.name}, try later"
            redirect_to all_following_places_path(username: current_user.username)
          end
        end
      else
        respond_to_request( false, "Please add at least one place to follow !" )
      end
    rescue Exception => e
      # catch all the exceptions
      Rails.logger.error "Some error bulged in => #{e.message}"
      respond_to_request( false, "there was some problem, please try later" )
    end
  end

  def remove_places
    place_id = params[:unfollow_place_id]
    if ( join_value=UserFollowedPlace.find_by_user_id_and_place_id( current_user.id, place_id )) and ( place=Place.find( place_id ) and (place.following_users_count > 0))
      if ( join_value.delete and 
            MetaRoad.decrement_count( current_user, 'following_places_count' ) and 
            MetaRoad.decrement_count( place, 'following_users_count' )
          )
        flash[:notice] = "You have unfollowed #{params[:unfollow_place_name]}"
        redirect_to all_following_places_path( current_user )
      end
    else
      flash[:alert] = "Could not find the place to unfollow !"
      redirect_to all_following_places_path( current_user )
    end
  end

  def recommend
    # dirty hack for flash here !
    flash.delete(:notice) && flash.delete(:alert)
    @recommended_places = PlaceRecommender.new( current_user ).recommend
  end

  private

  def set_skip_and_continue
    if params.has_key?(:ref) and params[:ref] == 'sign_up'
      @skip_and_continue = true
    end
  end

  def respond_to_request( success, msg )
    if success
      flash[:notice] = msg
      redirect_to all_following_places_path( current_user )
      # redirect_to follow_places_path( current_user )
    else
      flash[:alert] = msg
      redirect_to all_following_places_path( current_user )
    end
  end
end
