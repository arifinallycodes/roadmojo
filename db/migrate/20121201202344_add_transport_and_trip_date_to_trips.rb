class AddTransportAndTripDateToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :transport, :string
    add_column :trips, :trip_date, :date
  end
end
