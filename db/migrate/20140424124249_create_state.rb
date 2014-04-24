class CreateState < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.point :coordinates, srid: 4326
      t.integer :country_id
      t.string :name
      t.geometry :boundary_polygon, srid: 3785
    end
  end
end
