class LibraryItem < ActiveRecord::Base
  attr_accessible :name, :item_type, :description
  belongs_to :location, polymorphic: true

  ITEM_TYPE = ['Cafe', 'Restaurant', 'Pub/Bar', 'Accommodation', 'Point of Interest', 'View Point', 'Fuel/Service Station', 'Other']

  validates :name, presence: true
  validates :item_type, presence: true, inclusion: { in: ITEM_TYPE, message: "%{value} is not considered a library item type." }

  def self.find_or_create_by_hash(item_hash)
    self.where(item_hash.except("place")).find do |item|
      item.trip_places.find { |trip_place| trip_place.place_name == item_hash["place"] }
    end || self.create(item_hash.except("place"))
  end

  # def as_json(options = {})
  #   super(only: %i(id name item_type description))
  # end
end
