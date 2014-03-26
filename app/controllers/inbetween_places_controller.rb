class InbetweenPlacesController < ApplicationController
  before_filter :check_ajax

  def update
    place = InbetweenPlace.find(params[:place_id])
    place.update_attributes(params.slice(:description))
    render nothing: true
  end

  def show
    render json: InbetweenPlace.find(params[:place_id])
  end
end
