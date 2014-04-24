class Image < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :caption
      t.integer :object_id
      t.string :object_type
      t.text :description
    end
  end
end
