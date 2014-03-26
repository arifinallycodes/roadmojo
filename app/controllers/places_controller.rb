class PlacesController < ApplicationController
  before_filter :authenticate_user!
end
