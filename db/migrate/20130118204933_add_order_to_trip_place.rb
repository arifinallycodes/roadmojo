class AddOrderToTripPlace < ActiveRecord::Migration
  def change
    add_column :trip_places, :order, :integer
  end
end
