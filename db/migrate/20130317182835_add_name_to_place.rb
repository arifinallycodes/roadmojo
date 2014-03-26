class AddNameToPlace < ActiveRecord::Migration
  def change
    add_column :places, :name, :string
    remove_column :trip_places, :place_name
  end
end
