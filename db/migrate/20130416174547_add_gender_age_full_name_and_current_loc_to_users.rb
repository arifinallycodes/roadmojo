class AddGenderAgeFullNameAndCurrentLocToUsers < ActiveRecord::Migration
  def change
    add_column :users, :age, :integer
    add_column :users, :gender, :string
    add_column :users, :full_name, :string
    add_column :users, :current_loc, :string
  end
end
