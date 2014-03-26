class AddDescriptionToInbetweenPlace < ActiveRecord::Migration
  def change
    add_column :inbetween_places, :description, :string
  end
end
