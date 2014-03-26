class RenameLatLonInPlaces < ActiveRecord::Migration
  def change
    rename_column :places, :latitude, :lat
    rename_column :places, :longitude, :lon
  end
end
