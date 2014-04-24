class CreateVillage < ActiveRecord::Migration
  def change
    create_table :villages do |t|
      t.integer :region_id
      t.string :name
      t.point :coordinates, srid: 4326
    end
  end
end
