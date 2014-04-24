class Comment < ActiveRecord::Migration
  def change
      create_table :comments do |t|
          t.string :object_type
          t.integer :object_id
          t.text :description
          t.integer :user_id
      end
  end
end
