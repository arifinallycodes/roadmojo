class Admin::HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    if User::PRIVILEGED_EMAILS.include?( current_user.email )
      @users = User.all
      @places = Place.all
      @trips = Trip.all
      @library_items = LibraryItem.all
      @special_emails = SpecialEmail.all
    else
      # Display 404
      raise ActiveRecord::RecordNotFound
    end
  end
end
