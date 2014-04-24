class Trips::Milestone < ActiveRecord::Base
  belongs_to :trip
  belongs_to :location, polymorphic: true
end
