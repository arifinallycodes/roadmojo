class Tag < ActiveRecord::Migration
  def change
      create_table :images_tags do |t|
          t.string :tag_text
      end
  end
end
