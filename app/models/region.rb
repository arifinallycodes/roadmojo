class Region < ActiveRecord::Base
  belongs_to :state
  has_many :cities
  has_many :villages
end
