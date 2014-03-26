class LibraryItemsController < ApplicationController
  before_filter :check_ajax

  def index
    @location = get_location
    @library_items = @location.library_items
    @type_of_page = params[:type_of_page]
    render :index, layout: false
  end

  def show
    # Return JSON with type, name and description of the item
    @library_item = LibraryItem.find(params[:item_id])
    render :show, layout: false
  end

  def create
    location = get_location
    # params[:item] is a hash with :name, :item_type, :description keys
    location.library_items << LibraryItem.create(params[:item])
    render nothing: true
  end

  def update
    item = LibraryItem.find(params[:item][:id])
    item.update_attributes(params[:item].except(:id))
    render nothing: true
  end

  def delete
    LibraryItem.find(params[:item_id][/\d+$/]).delete
    render nothing: true
  end

  private

  def get_location
    if (tp_id = params[:trip_place_id])
      TripPlace.find(tp_id)
    elsif (inb_id = params[:inbetween_id])
      InbetweenPlace.find(inb_id)
    end
  end
end
