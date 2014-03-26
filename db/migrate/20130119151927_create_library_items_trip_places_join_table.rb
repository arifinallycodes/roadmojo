class CreateLibraryItemsTripPlacesJoinTable < ActiveRecord::Migration
  def change
    create_table :library_items_trip_places, id: false do |t|
      t.integer :library_item_id
      t.integer :trip_place_id
    end
    add_index :library_items_trip_places, [:library_item_id, :trip_place_id],
      unique: true, name: "item_trip_place_index"
  end
end
