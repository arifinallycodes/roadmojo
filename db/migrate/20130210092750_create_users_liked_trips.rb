class CreateUsersLikedTrips < ActiveRecord::Migration
  def change
    create_table :users_liked_trips do |t|
      t.references :user
      t.references :trip

      t.timestamps
    end
    add_index :users_liked_trips, :user_id
    add_index :users_liked_trips, :trip_id
  end
end
