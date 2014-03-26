class RenameFileToImageInPhotos < ActiveRecord::Migration
  def change
  	rename_column :photos, :file, :image
  end
end
