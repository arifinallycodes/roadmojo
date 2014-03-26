class AddDescriptionToLibraryItem < ActiveRecord::Migration
  def change
    add_column :library_items, :description, :text
  end
end
