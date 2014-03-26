class RenameTripNameInTrip < ActiveRecord::Migration
  def change
    rename_column :trips, :trip_name, :name
  end
end
