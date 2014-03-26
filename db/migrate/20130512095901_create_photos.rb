class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
    	t.string :file
    	t.text :name
    	t.references :user
      t.timestamps
    end
  end
end
