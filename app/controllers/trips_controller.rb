class TripsController < ApplicationController
  include TripsHelper

  respond_to :html, :json
  before_filter :authenticate_user!, except: [ :index, :show, :top, :edit ]
  before_filter :proceed_if_owner,   except: [ :index, :show, :top, :edit ]
  before_filter :find_user_by_username, except: [:top]

  def index
    # @trips = @user.trips.order('created_at DESC')
    @trips = @user.trips.where('trips.draft_version = ?', false).order('updated_at DESC').page(params[:page]).per(10)
    @draft_trips = @user.trips.where('trips.draft_version = ?', true).order('updated_at DESC')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @trips }
    end
  end

  def show
    @trip = @user.trips.find(params[:id]).decorate
    @locations = @trip.locations
    @li_count_for_first_location = @locations.first.library_items.count if !@locations.size.zero?

    if !(current_user != @user and @trip.draft_version?)
      # On successfully sharing a trip on Facebook, FB would send the id of the post 
      # shared as a query parameter "post_id" on the callback url. Thus, check for post_id.
      if params[:post_id]
        @trip.increase_trip_share_counter
        flash[:notice] = "Successfully shared this trip on Facebook !"
      end
      if request.path != trip_path(@trip.user.slug, @trip)
        redirect_to trip_path(@trip.user.slug, @trip), status: :moved_permanently 
      else
        @places = @trip.places
        @coords = @places.map { |h| [h.lat.to_s, h.lon.to_s] }
        @transport = @trip.transport

        # flash[:notice] = "This is a draft version of the trip, hence it can only be viewed by you" if @trip.draft_version?
      end
    else
      # display 404 page not found error
      raise ActiveRecord::RecordNotFound
    end
  end

  # step - 1
  def new
    @trip = current_user.trips.new
    @form_url = trips_path(current_user)
    @trip_step = 'new_trip'
    @places = []
  end

  # step 1 - save button
  def create
    @trip = current_user.trips.new(params[:trip].except(:places))
    @trip.draft_version = true
    if params[:commit] == "Save"
      save_and_nothing
    elsif params[:commit] == "Save as draft"
      save_trip_as_draft
    else
      save_and_continue
    end
  end

  def save_and_nothing
    if @trip.save
      redirect_to trip_path(current_user, @trip)
    else
      flash.now[:error] = @trip.errors.full_messages
      @places = params[:trip][:places]
      render "new"
    end  
  end

  # step - 1 save and continue button
  def save_and_continue
    if @trip.save
      redirect_to trip_add_places_path(current_user, @trip)
    else
      flash.now[:error] = @trip.errors.full_messages
      @form_url = trips_path(current_user)
      @trip_step = 'new_trip'
      @places = params[:trip][:places]
      render "new"
    end
  end

  # step - 2 add the places for your trip
  def add_places
    @trip = current_user.trips.find(params[:trip_id])
    @places = @trip.places
    @no_of_library_items = @trip.no_of_library_items
    if flash[:from_edit]
      empty_flash
      @trip_step = 'edit_trip'
    end
  end

  def save_added_places
    if params[:from] == 'edit_trip'
      @trip_step == 'edit_trip'
    end
    if params[:commit] == "Save as draft"
      save_added_places_as_draft_and_nothing
    else
      save_added_places_and_continue
    end
  end

  def save_trip_as_draft
    @trip ||= current_user.trips.find(params[:trip_id])
    @trip.draft_version = true
    if @trip.save
      flash[:notice] = "Trip has been saved in your drafts"
      redirect_to trips_path(current_user)
    else
      flash.now[:error] = @trip.errors.full_messages
      @places = params[:trip][:places]
      render "new"
    end  
  end
  
  # TODO:
  #   Add an else case !
  # step - 2 save those places
  def save_added_places_as_draft_and_nothing
    add_places_pre
    @trip.draft_version = true
    if @trip.save
      if !@empty_places
        redirect_to trip_path(current_user, @trip)
      else
        @places =[]
        flash[:alert] = "You need to add at least two places to continue !!"
        redirect_to trip_add_places_path( current_user, @trip )
      end
    else
      flash[:alert] = @trip.error.full_messages
      redirect_to trip_add_places_path( current_user, @trip )
    end
  end

  # step - 2 save and continue to add library items
  def save_added_places_and_continue
    add_places_pre
    draft_version = @trip.draft_version?
    if draft_version and !@no_of_places.zero?
      flash[:notice]=" IMPORTANT! You will not be able to change the places list once you add library items here. Please ensure the places are correct and complete. To edit, please click the Previous button."
      redirect_to trip_library_items_path(current_user, @trip)
    elsif draft_version and @no_of_places.zero?
      redirect_to dashboard_path
    elsif !@empty_places
      flash[:notice]=" IMPORTANT! You will not be able to change the places list once you add library items here. Please ensure the places are correct and complete. To edit, please click the Previous button."
      redirect_to trip_library_items_path(current_user, @trip)
    else
      @places =[]
      flash[:alert] = "You need to add at least two places to continue !!"
      redirect_to trip_add_places_path( current_user, @trip )
    end
  end

  # step - 3 add library items
  def edit_library_items
    @trip = current_user.trips.find(params[:trip_id])
    @locations = @trip.locations
    if flash[:moved_to_step_3]
      empty_flash
      @skipped_step_2 = true
      flash[:notice] = 'Step 2 skipped. You are not allowed to add or modify places as you have library items present in your trip.'
    end
  end

  def edit
    @trip_step = 'edit_trip'
    @trip = current_user.trips.find(params[:id])
    @form_url = trip_path(current_user, @trip)
    @places = @trip.places
  end

  def update
    @trip = current_user.trips.find(params[:id])
    @form_url = trip_path(current_user, @trip)
    if params[:commit] == 'Update as draft'
      update_as_draft_and_nothing
    else
      update_and_next
    end
  end

  # update step - 1 and nothing
  def update_as_draft_and_nothing
    params[:trip][:draft_version] = true
    if @trip.update_attributes(params[:trip].except(:places))
      flash[:notice] = "Updated basic information of trip - #{@trip.name}"
      redirect_to trip_path(current_user, @trip)
    else
      flash.now[:error] = @trip.errors.full_messages
      render "edit"
    end
  end

  # update step - 2 and next
  def update_and_next
    if @trip.update_attributes(params[:trip].except(:places))
      flash[:notice] = "Updated basic information of trip - #{@trip.name}"
      if @trip.no_of_library_items > 0
        flash[:moved_to_step_3] = true
        redirect_to trip_library_items_path(current_user, @trip)
      else
        flash[:from_edit] = true
        redirect_to trip_add_places_path(current_user, @trip)
      end
    else
      flash.now[:error] = @trip.errors.full_messages
      render "edit"
    end
  end

  def destroy
    user = User.find(params[:username])
    @trip = user.trips.find(params[:id])
    @trip.destroy

    respond_to do |format|
      format.html { redirect_to trips_url(current_user) }
      format.json { head :no_content }
    end
  end

  def top
    @trips = Trip.where('draft_version != ?',true).order('no_of_likes DESC').limit(10)
  end

  def publish_trip
    @trip ||= current_user.trips.find( params[:trip_id] )
    places = @trip.places
    @trip.draft_version = false
    if places.count >= 2
      if @trip.save
        redirect_to trip_path(current_user, @trip)
      else
        redirect_to trip_path(current_user, @trip), alert: @trip.errors.full_messages 
      end
    elsif !@trip.valid?
      @trip.errors[:base] = "Please add at least two places to the trip"
      redirect_to trip_path(current_user, @trip), alert: @trip.errors.full_messages
    else
      redirect_to trip_path(current_user, @trip)
    end
  end

  private

  def proceed_if_owner
    if !current_user?
      flash[:error] = "Cannot modify/delete this trip since it does not belong to you"
      redirect_to trips_path
    end
  end

  def update_trips_and_inbetween_places
    if params.has_key?(:trip)
      @no_of_places = params[:trip][:places].length
      if @no_of_places >= 2 or @trip.draft_version?
        @empty_places = false
        params[:trip][:places] ||= []
        @trip.update_trip_places(params[:trip][:places])
        @trip.update_inbetween_places
      else
        @empty_places = true
      end
    elsif @trip.draft_version?
      @no_of_places = 0
      @empty_places = false
    else
      @empty_places = true
    end
  end

  def add_places_pre
    @trip = current_user.trips.find(params[:trip_id])
    update_trips_and_inbetween_places
  end
end