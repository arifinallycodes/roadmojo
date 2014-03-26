class PlacesStep1Validator < ActiveModel::Validator
  def validate(record)
    # Google does not allow, so we dont allow (as of now)
    if record.trip_places.length > 10
      record.errors[:base] = "Sorry, as of now, you cannot add more than 10 places. Click here to request this feature "
    end
    if record.trip_date > Date.today
      record.errors[:base] = "Future trip date not allowed"
    end
  end
end

class PlacesStep2Validator < ActiveModel::Validator
  def validate(record)
    if record.trip_places.length < 2
      record.errors[:base] = "You have to visit at least two places with a trip"
    end

    record.places.each_cons(2) do |place1, place2|
      if place1.lat == place2.lat && place1.lon == place2.lon
        record.errors[:base] = "#{place1.name} is duplicated. Remove one or reorganize the route."
        break
      end
    end
  end
end

class Trip < ActiveRecord::Base
  belongs_to :user
  extend FriendlyId
  friendly_id :name, use: :scoped, scope: :user

  TRANSPORT = %w(Car Motorbike Bicycle Bus Other)

  attr_accessible :description, :name, :trip_places, :user, :transport, :trip_date, :draft_version, :no_of_shares

  has_many :trip_places, dependent: :destroy
  has_many :users_liked_trips
  has_many :users_liking_it, through: :users_liked_trips, source: :user #, foreign_key: 'user_id'
  has_many :photos

  validates_presence_of :name
  validates_presence_of :description, :trip_date, :if => Proc.new { |t| !t.draft_version }

  validates_with PlacesStep1Validator, 
                    :if => Proc.new { |t| !t.draft_version }, 
                    :on => :save_and_nothing

  validates_with PlacesStep1Validator, 
                    :if => Proc.new { |t| !t.draft_version }, 
                    :on => :save_and_continue
 
  validates_with PlacesStep2Validator, 
                    :if => Proc.new { |t| !t.draft_version },
                    :on => :save_added_places_and_nothing

  validates_with PlacesStep2Validator, 
                    :if => Proc.new { |t| !t.draft_version },
                    :on => :save_added_places_and_continue

  validate :date_validation, :if => Proc.new { |t| !t.draft_version }

  validates :transport, presence: true, 
                        inclusion: { in: TRANSPORT, message: "%{value} is not valid" }, 
                        :if => Proc.new { |t| !t.draft_version }


  # validate :date_validation 
  # Skip validations for draft_versions
  # with_options unless: :draft_version? do |trip|
  #   trip.validates_presence_of :name, :description, :trip_date
  #   trip.validates :transport, presence: true, inclusion: { in: TRANSPORT, message: "%{value} is not considered transportation." }
  #   trip.validates_with PlacesValidator
  # end

  def places
    trip_places.sort_by { |tp| tp.sort }.map(&:place)
  end

  def date_validation
    if trip_date > Date.today
      self.errors[:base] = "Future trip date not allowed"
    end
  end

  def place_names
    places.map(&:name)
  end

  def first_place
    place_names.first
  end

  def last_place
    place_names.last
  end

  def inbetween_places
    trip_places.each.with_object([]) do |tp, inbts|
      inbts << tp.inbetween_before << tp.inbetween_after
    end.compact.uniq
  end

  def locations
    trip_places.zip(inbetween_places).flatten.compact
  end

  def no_of_library_items
    count = 0
    self.locations.each do |location|
      count += location.library_items.count
    end
    return count
  end

  def update_trip_places(new_places)
    clear_trip_places_order
    new_places.each.with_index do |place_hash, index|
      existing_tp = get_trip_place(place_hash)
      if existing_tp
        existing_tp.update_attribute(:sort, index)
      else
        self.trip_places << TripPlace.create_from_hash(self.id, place_hash, index)
      end
    end
    delete_old_trip_places
  end

  def update_inbetween_places
    self.trip_places.each_cons(2) do |tp_before, tp_after|
      existing_inb = InbetweenPlace.where(place_before_id: tp_before.id, place_after_id: tp_after.id)
      InbetweenPlace.create(place_before: tp_before, place_after: tp_after) unless existing_inb.present?
    end
  end

  def has_place?(place_name)
    self.trip_places.find { |tp| tp.place_name == place_name && tp.sort.present? }
  end

  def increase_trip_share_counter
    if self.no_of_shares
      computed_counter = self.no_of_shares + 1
    else
      computed_counter = 1
    end
    begin
      self.update_column( :no_of_shares, computed_counter )
    rescue Exception
      Rails.logger.error "***** Unable to increase the no of shared column => #{self.errors.messages} *****"
    end
  end
  
  private

  def clear_trip_places_order
    self.trip_places.each { |tp| tp.update_attribute(:sort, nil) }
  end

  def get_trip_place(place_hash)
    self.trip_places.find { |tp| tp.place.location?(place_hash) && tp.sort.nil? }
  end

  def delete_old_trip_places
    self.trip_places.select { |tp| tp.sort.nil? }.each do |tp|
      # Delete items from trip place only if this was the last trip place
      # with given name.
      #tp.update_items([]) unless self.has_place?(tp.place_name)
      self.trip_places.delete(tp)
      TripPlace.delete(tp)
    end
  end
end
