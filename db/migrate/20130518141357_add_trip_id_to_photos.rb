class AddTripIdToPhotos < ActiveRecord::Migration
  def change
  	add_column :photos, :trip_id, :integer
  end
end
