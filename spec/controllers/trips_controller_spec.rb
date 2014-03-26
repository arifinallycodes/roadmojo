require "spec_helper"

describe TripsController do
  include Devise::TestHelpers

  before do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "GET #index" do
    before do
      get :index
    end
    
    it { should assign_to(:trips) }
    it { should render_template(:index) }
  end

  describe "GET #show" do
    before do
      @trip = FactoryGirl.create(:trip)
      get :show, id: @trip.id
    end

    it { should assign_to(:trip) }
    it { should assign_to(:places) }
    it { should render_template(:show) }
  end

  describe "GET #new" do
    before do
      get :new
    end

    it { should assign_to(:trip) }
  end

  describe "GET #edit" do
    context "by owner of the trip" do
      before do
        @trip = FactoryGirl.create(:trip, user_id: @user.id)
        get :edit, id: @trip.id
      end

      it { should assign_to(:trip) } 
      it { should assign_to(:places) }
      it { should render_template(:edit) }
      it { should_not set_the_flash }
    end

    context "by another user" do
      before do
        another_user = FactoryGirl.create(:user)
        @trip = FactoryGirl.create(:trip, user_id: another_user.id)
        get :edit, id: @trip.id
      end

      it { should_not render_template(:edit) }
      it { should redirect_to trips_path }
      it { should set_the_flash }
    end
  end

  describe "POST create" do
    before do
      @trip = FactoryGirl.attributes_for(:trip)
      trip_places_array = Array.new(3) { FactoryGirl.attributes_for(:place).merge(FactoryGirl.attributes_for(:trip_place)) }
      @trip_places_hash = Hash[(1..trip_places_array.size).to_a.zip(trip_places_array)]
      @trip[:trip_places] = @trip_places_hash
    end

    context "with valid data" do
      before do
        post :create, trip: @trip
      end

      it { should assign_to(:trip) }
      it { should set_the_flash }
      it { should redirect_to(Trip.first) }
    end

    context "with invalid data" do
      before do
        @trip["name"] = nil
        post :create, trip: @trip
      end

      it { should assign_to(:trip) }
      it { should_not redirect_to(Trip.first) }
      it { should render_template(:new) }
    end
  end

  describe "PUT update" do
    context "by owner of the trip" do
      before do
        @trip = FactoryGirl.create(:trip, user_id: @user.id)
      end

      context "with correct attributes" do
        before do
          @trip_params = { name: "New name" }
          put :update, id: @trip.id, trip: @trip_params
        end

        it { should assign_to(:trip) }
        it { should set_the_flash }
        it { should redirect_to(@trip) }
      end

      context "with incorrect attributes" do
        before do
          @trip_params = { name: "" }
          put :update, id: @trip.id, trip: @trip_params
        end

        it { should assign_to(:trip) }
        it { should_not redirect_to(@trip) }
        it { should render_template(:edit) }
      end
    end

    context "by another user" do
      before do
        @trip = FactoryGirl.create(:trip)
        @trip_params = { id: @trip.id, name: "New name" }
        put :update, id: @trip.id, trip: @trip_params
      end

      it { should_not assign_to(:trip) }
      it { should set_the_flash }
      it { should redirect_to(:trips) }
    end
  end
end
