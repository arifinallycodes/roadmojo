class CreateUserFollowedPlaces < ActiveRecord::Migration
  def change
    create_table :user_followed_places do |t|
      t.references :user
      t.references :trip_place

      t.timestamps
    end
    add_index :user_followed_places, :user_id
    add_index :user_followed_places, :trip_place_id
  end
end
