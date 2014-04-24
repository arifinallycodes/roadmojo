class CreateRegion < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.integer :state_id
      t.string :name
      t.geometry :boundary_polygon, srid: 3785
    end
  end
end
