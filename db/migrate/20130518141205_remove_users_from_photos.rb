class RemoveUsersFromPhotos < ActiveRecord::Migration
  def change
  	remove_column :photos, :user_id
  end
end
