class CreateTripPlaces < ActiveRecord::Migration
  def change
    create_table :trip_places do |t|
      t.references :trip
      t.references :place

      t.timestamps
    end
    add_index :trip_places, :trip_id
    add_index :trip_places, :place_id
  end
end
