class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :object_id
      t.string :object_type
      t.integer :priority
      t.text :caption

      t.timestamps
    end
  end
end
