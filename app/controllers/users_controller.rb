class UsersController < ApplicationController
  before_filter :find_user_by_username, except: [:dashboard]

  before_filter :clear_flash, only: [:dashboard]

  # layout :user_layout, only: [:dashboard]

  def show
    @draft_trips = @user.trips.where('draft_version=?',true).limit(2).order('created_at DESC')
    @no_of_liked_trips = @user.liked_trips.count
  end

  def dashboard
    # Get nearby trips
    # In development env, the current sign in ip is 127.0.0.1 and Geokit would not 
    # return you anything. Thus, the modification and necessity of this dirty little
    # mess here !
    if current_user
      @user = current_user
      if Rails.env.development?
        @nearby_trips = NearbyTrip.new(@user, "122.161.98.169",1000).trips
      else
        @nearby_trips = NearbyTrip.new( @user, "#{@user.current_sign_in_ip}", 1000 ).trips
      end

      if @user.present?
        if @user == current_user
          # @trips = @user.trips.where('draft_version=?',false)
          @draft_trips = @user.trips.where('draft_version=?',true).limit(2).order('updated_at DESC')
          @trips_from_followed_places = UserFollow.new( @user ).trips.where('draft_version=?',false)
          @trips = (@nearby_trips | @trips_from_followed_places | @user.trips).sort_by!{ |trip| trip.updated_at }.reverse
        else
          redirect_to trips_path(@user)
        end
      else
        redirect_to dashboard_path, notice: "User #{params[:username]} not found"
      end
    else
      render 'home/index'
    end
  end

  private 

  def clear_flash
    [:notice, :alert].each do |key|
      flash.delete(key)
    end
  end

  def user_layout
    user_signed_in? ? "application" : "landing_page"
  end
end