class CreateImagesImageTags < ActiveRecord::Migration
  def change
    create_table :images_image_tags do |t|
      t.integer :image_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
