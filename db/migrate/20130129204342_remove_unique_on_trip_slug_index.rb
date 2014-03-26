class RemoveUniqueOnTripSlugIndex < ActiveRecord::Migration
  def change
    remove_index :trips, :slug
    add_index :trips, :slug
  end
end
