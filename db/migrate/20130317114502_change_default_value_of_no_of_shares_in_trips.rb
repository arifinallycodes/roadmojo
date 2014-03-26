class ChangeDefaultValueOfNoOfSharesInTrips < ActiveRecord::Migration
  def change
  	change_column :trips, :no_of_shares, :integer, default: 0, null: false
  end
end
