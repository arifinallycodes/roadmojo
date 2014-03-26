class AddingAssociationOfUsersWithPlaces < ActiveRecord::Migration
  def change
    add_column :user_followed_places, :place_id, :integer
  end
end
