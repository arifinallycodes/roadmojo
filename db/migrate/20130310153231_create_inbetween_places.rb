class CreateInbetweenPlaces < ActiveRecord::Migration
  def change
    create_table :inbetween_places do |t|
      t.references :place_before
      t.references :place_after

      t.timestamps
    end
    add_index :inbetween_places, :place_before_id
    add_index :inbetween_places, :place_after_id
  end
end
