class CreateCity < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.integer :region_id
      t.string :name
      t.point :coordinates, srid: 4326
    end
  end
end
