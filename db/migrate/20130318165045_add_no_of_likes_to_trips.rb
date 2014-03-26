class AddNoOfLikesToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :no_of_likes, :integer, default: 0, null: false
  end
end
