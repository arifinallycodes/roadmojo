class RemoveNameFromPlace < ActiveRecord::Migration
  def up
    remove_column :places, :name
  end

  def down
    add_column :places, :name, :string
  end
end
