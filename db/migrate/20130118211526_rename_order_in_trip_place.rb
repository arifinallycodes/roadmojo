class RenameOrderInTripPlace < ActiveRecord::Migration
  def change
    rename_column :trip_places, :order, :sort
  end
end
