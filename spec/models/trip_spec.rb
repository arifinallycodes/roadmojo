require "spec_helper"

describe Trip do
  before do
    @trip = Trip.new(name: "First trip", description: "Bla")
    @wroclaw = Place.new(lat: 12.34, lon: 56.78)
    @berlin = Place.new(lat: 56.12666, lon: 11.111)
    @poznan = Place.new(lat: 98.76, lon: 93.543)
  end

  pending "should not be valid with no places" do
    @trip.should_not be_valid
  end

  pending "should not be valid with one place" do
    @trip.places << @wroclaw
    @trip.should_not be_valid
  end

  describe "with two places" do
    before do
      @trip.places << @wroclaw
      @trip.places << @berlin
    end

    pending "should be valid" do
      @trip.should be_valid
    end

    pending "should have two places" do
      @trip.places.size.should == 2
    end

    pending "should have correct places order" do
      @trip.places[0].name.should == @wroclaw.name
      @trip.places[1].name.should == @berlin.name
    end

    describe "should have the possibility to change first place" do
      before do
        @trip.places[0] = @poznan
      end

      pending "and have correct places order" do
        @trip.places[0].name.should == @poznan.name
        @trip.places[1].name.should == @berlin.name
      end

      describe "and the second" do
        before do
          @trip.places[1] = @wroclaw
        end

        pending "and have correct places order" do
          @trip.places[0].name.should == @poznan.name
          @trip.places[1].name.should == @wroclaw.name
        end
      end
    end

    describe "should be able to add the same place again" do
      before do
        @trip.places << @wroclaw
      end

      pending "should have correct places order" do
        [@wroclaw, @berlin, @wroclaw].each_with_index do |place, index|
          @trip.places[index].name.should == place.name
        end
      end
    end
  end

  pending "can be created with many places" do
    places = 8.times.with_object([]) { |nr, obj| obj << Place.new(lat: rand(10000) / 100.0, lon: rand(10000) / 100.0) }
    @trip.places.concat(places)
    @trip.should be_valid
  end
end
