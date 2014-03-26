class CreateLibraryItems < ActiveRecord::Migration
  def change
    create_table :library_items do |t|
      t.string :name
      t.string :type

      t.timestamps
    end
  end
end
