class CreateTripsMoments < ActiveRecord::Migration
  def change
    create_table :trips_moments do |t|
      t.references :milestone, index: true
      t.string :location_type
      t.integer :location_id
      t.text :description
      t.datetime :visiting_date
      t.boolean :are_any_milestones_before_it

      t.timestamps
    end
  end
end
