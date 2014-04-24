class Notification < ActiveRecord::Migration
  def change
      create_table :notifications do |t|
          t.integer :user_id
          t.integer :object_id
          t.string :object_type
      end

  end
end
