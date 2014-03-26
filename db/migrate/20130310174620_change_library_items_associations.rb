class ChangeLibraryItemsAssociations < ActiveRecord::Migration
  def change
    drop_table :library_items_trip_places
    change_table :library_items do |t|
      t.references :location, polymorphic: true
    end
  end
end
