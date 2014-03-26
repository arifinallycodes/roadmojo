class AddNoOfLikesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :no_of_likes, :integer, default: 0, null: false
  end
end
