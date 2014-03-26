class AddDraftVersionToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :draft_version, :boolean, default: false
  end
end
