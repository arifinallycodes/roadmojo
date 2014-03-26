class AddCountOfFollowingPlacesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :following_places_count, :integer, default: 0
  end
end
