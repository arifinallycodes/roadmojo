class RemovingTripPlacesAssociationWithUsers < ActiveRecord::Migration
  def change
    remove_column :user_followed_places, :trip_place_id
  end 
end
