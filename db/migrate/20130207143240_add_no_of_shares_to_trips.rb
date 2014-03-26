class AddNoOfSharesToTrips < ActiveRecord::Migration

  def change
    add_column :trips, :no_of_shares, :integer
  end
  
end
