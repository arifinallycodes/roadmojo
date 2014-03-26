class AddLatitudeAndLongitudeToPlace < ActiveRecord::Migration
  def change
    add_column :places, :latitude, :decimal
    add_column :places, :longitude, :decimal
  end
end
