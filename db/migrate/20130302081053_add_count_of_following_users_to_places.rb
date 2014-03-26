class AddCountOfFollowingUsersToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :following_users_count, :integer, default: 0
  end
end
