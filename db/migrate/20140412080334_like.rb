class Like < ActiveRecord::Migration
  def change
      create_table :likes do |t|
          t.string :object_type
          t.integer :object_id
          t.integer :user_id
      end
  end
end
