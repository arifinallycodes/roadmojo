class AddPlaceNameToTripPlaces < ActiveRecord::Migration
  def change
    add_column :trip_places, :place_name, :string
  end
end
