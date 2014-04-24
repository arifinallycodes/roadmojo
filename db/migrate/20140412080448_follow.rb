class Follow < ActiveRecord::Migration
  def change
      create_table :follows do |t|
          t.integer :user_id
          t.string :object_id
          t.integer :object_type
      end
  end
end
