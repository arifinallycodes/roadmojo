class Trips::Moment < ActiveRecord::Base
  belongs_to :milestone,class_name: "::Trips::Milestone"
  belongs_to :location,polymorphic: true
end
