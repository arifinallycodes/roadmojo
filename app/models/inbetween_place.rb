class InbetweenPlace < ActiveRecord::Base
  belongs_to :place_before, class_name: "TripPlace", foreign_key: "place_before_id"
  belongs_to :place_after, class_name: "TripPlace", foreign_key: "place_after_id"
  has_many :library_items, as: :location

  attr_accessible :place_before, :place_after, :description

  def to_s
    "#{place_before.place.name} - #{place_after.place.name}"
  end

  # def as_json(options = {})
  #   super(only: :description)
  # end
end
