class CreateCountry < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.point :coordinates, srid: 4326
      t.string :name
    end
  end
end
