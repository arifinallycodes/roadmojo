class CreateTripsMilestones < ActiveRecord::Migration
  def change
    create_table :trips_milestones do |t|
      t.references :trip, index: true
      t.string :location_type
      t.integer :location_id
      t.text :description
      t.datetime :visiting_date
      t.string :road_condition

      t.timestamps
    end
  end
end
