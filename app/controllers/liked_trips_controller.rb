class LikedTripsController < ApplicationController
  before_filter :find_user_by_username
  before_filter :authenticate_user!, except: [:index]

  def index
    # @trips = current_user.liked_trips
    @trips = @user.liked_trips.page(params[:page]).per(10)
    respond_to do |format|
      format.html
      format.json { render json: @trips.to_json, status: :ok }
    end
  end

  # POST /:username/trips/:trip_id/like
  def like
    trip = @user.trips.find_by_slug( params[:trip_id] )
    respond_to do |format|
      if current_user != trip.user
        if !current_user.liked_trips.find_by_id( trip.id )
          if current_user.liked_trips << trip and MetaRoad.increment_count( current_user, 'no_of_likes' ) and MetaRoad.increment_count( trip, 'no_of_likes' )
            LikeMailer.delay.like_trip( @user, current_user, trip )
            format.html { 
              flash[:notice] = "Successfully liked trip #{trip.name}"
              redirect_to trips_url( current_user )
            }
            format.json { render json: trip, status: 200 }
          else
            format.html { 
              flash[:alert] = " Something went wrong, please try again !"
              redirect_to dashboard_path( current_user ) 
            }
            format.json { render json: trip.errors.full_messages, status: :unprocessable_entity  }
          end
        else
          format.html{ 
            flash[:alert] = "You can't like a trip more than once !"
            redirect_to trips_path 
          }
          format.json{ render json: "You can't like a trip more than once !", status: :unprocessable_entity }
        end
      else
        format.html{ 
          flash[:alert] = "Kinda lame, you want to like your own trips ?!"
          redirect_to trips_path 
        }
        format.json{ render json: "You can't like a trip more than once !", status: :unprocessable_entity }
      end
    end
  end

  # POST /:username/trips/:trip_id/unlike
  def unlike
    trip = @user.trips.find_by_slug( params[:trip_id] )
    # trip = Trip.find( params[:slug] )

    respond_to do |format|
      if ( join_value = UsersLikedTrip.find_by_user_id_and_trip_id( current_user.id, trip.id ) )
        if join_value.delete and MetaRoad.decrement_count( current_user, 'no_of_likes' ) and MetaRoad.decrement_count( trip, 'no_of_likes' )
          format.html { 
            flash[:notice] = "Unliked the trip !"
            redirect_to trips_url( current_user ) 
          }
          format.json { render json: trip, status: 200  }
        else
          format.html { 
            flash[:alert]  = "Something went wrong, please unliking the trip back later !"
            redirect_to trips_path( current_user ) 
          }
          format.json { render json: trip, head: :no_content  }
        end
      else
        format.html { 
          flash[:alert] = "Can't unlike a trip that you dont like !"
          redirect_to dashboard_path( current_user ) 
        }
        format.json { render json: trip.errors.full_messages, status: :unprocessable_entity  }
      end
    end
  end
end