class RenameTypeInLibraryItems < ActiveRecord::Migration
  def change
    rename_column :library_items, :type, :item_type
  end
end
