class CreateImagesTags < ActiveRecord::Migration
  def change
    create_table :images_tags do |t|
      t.integer :object_id
      t.string :object_type
      t.string :value

      t.timestamps
    end
  end
end
