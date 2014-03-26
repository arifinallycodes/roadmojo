class RemoveEmailFieldFromTrips < ActiveRecord::Migration
  def up
    remove_column :trips, :email
  end

  def down
    add_column :trips, :email, :string
  end
end
