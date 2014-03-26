class Place < ActiveRecord::Base
  attr_accessible :lat, :lon, :name

  has_many :trip_places
  has_many :trips, through: :trip_places

  # Follow options associations
  has_many :user_followed_places
  has_many :users_following_it, through: :user_followed_places, source: :user


  def location?(place_hash)
    self.lat.to_s == place_hash[:lat] && self.lon.to_s == place_hash[:lon]
  end

  def self.find_or_create_by_hash(hash)
    self.find_by_lat_and_lon(hash[:lat], hash[:lon]) || self.create!(lat: hash[:lat], lon: hash[:lon], name: hash[:name])
  end
end
