require "spec_helper"

describe TripPlace do
  describe "self.create_from_hash" do
    before do
      @place_name = "Taipei City"
      @lat = BigDecimal.new("25.033333")
      @lon = BigDecimal.new("121.633333")
      @place_hash = { place_name: @place_name, lat: @lat, lon: @lon }
    end

    it "should create a location when it is not yet created" do
      -> { TripPlace.create_from_hash(1, @place_hash) }.should change(Place, :count).by(1)
    end

    it "should not create a location when it is already created" do
      Place.new(lat: @lat, lon: @lon).save
      -> { TripPlace.create_from_hash(2, @place_hash) }.should_not change(Place, :count)
    end
  end
end
