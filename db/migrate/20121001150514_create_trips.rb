class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.string :trip_name
      t.string :source
      t.string :destination
      t.text :description
      t.string :email

      t.timestamps
    end
  end
end
