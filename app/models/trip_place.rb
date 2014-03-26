class TripPlace < ActiveRecord::Base

  # === Associations ===
  belongs_to :trip
  belongs_to :place
  attr_accessible :trip_id, :place_id, :sort, :inbetween_before, :inbetween_after
  has_many :library_items, as: :location
  has_one :inbetween_before, class_name: "InbetweenPlace", foreign_key: "place_after_id", dependent: :destroy
  has_one :inbetween_after, class_name: "InbetweenPlace", foreign_key: "place_before_id", dependent: :destroy
  
  default_scope order: "sort"

  def self.create_from_hash(trip_id, hash, sort_order)
    place = Place.find_or_create_by_hash(hash)
    self.new(trip_id: trip_id,
             place_id: place.id,
             sort: sort_order)
  end

  def to_s
    place.name
  end

  def update_items(item_list)
    # Delete items not present in the item list (removed from trip_place)
    #self.library_items.each do |item|
      #LibraryItem.delete(item) unless item_list.find do |hash|
        #item.name == hash["name"] && item.item_type == hash["item_type"]
      #end
    #end

    ## Add items present in item list, if not yet added
    #item_list.each do |item_hash|
      #item = LibraryItem.find_or_create_by_hash(item_hash)
      #self.library_items << item unless item.trip_places.include? self
    #end
  end
end
