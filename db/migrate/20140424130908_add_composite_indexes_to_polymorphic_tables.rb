class AddCompositeIndexesToPolymorphicTables < ActiveRecord::Migration
  def change
  	add_index(:notifications, [:object_id, :object_type], name: 'by class id notifications')
  	add_index(:comments, [:object_id, :object_type], name: 'by class id comments')
  	add_index(:likes, [:object_id, :object_type],  name: 'by class id likes')
  	add_index(:follows, [:object_id, :object_type], name: 'by class id follows')
  	add_index(:likes, :user_id)
  	add_index(:comments, :user_id)
  	add_index(:follows, :user_id)
  	add_index(:notifications, :user_id)
  	add_index(:images, [:object_id,:object_type], name: 'by class id images')
  	add_index :regions, [:boundary_polygon], :name => "index_regions_on_boundary_polygon", :spatial => true
  	add_index :states, [:boundary_polygon], :name => "index_states_on_boundary_polygon", :spatial => true
  	add_index :cities, [:coordinates], :name => "index_cities_on_coordinates", :spatial => true
  	add_index :states, [:coordinates], :name => "index_states_on_coordinates", :spatial => true
  	add_index :villages, [:coordinates], :name => "index_villages_on_coordinates", :spatial => true
  end
end
