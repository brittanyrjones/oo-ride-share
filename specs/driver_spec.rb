require_relative 'spec_helper'

describe "Driver class" do
  before do
    @trip_1 = RideShare::Trip.new(id: 1, driver: 1, passenger: 54, start_time: Time.parse('2016-04-05T14:01:00+00:00'), end_time: Time.parse('2016-04-05T14:09:00+00:00'), cost: 17.39, rating: 3)
    @trip_2 = RideShare::Trip.new(id: 122, driver: 1, passenger: 247, start_time: Time.parse('2015-12-24T04:57:00+00:00'), end_time: Time.parse('2015-12-24T04:57:00+00:00'), cost: 13.11, rating: 5)
    @driver = RideShare::Driver.new(id: 1, name: "Bernardo Prosacco", vin: "WBWSS52P9NEYLVDE9", status: :UNAVAILABLE, trips: [])
  end


  describe "Driver instantiation" do
    before do
      @driver = RideShare::Driver.new(id: 1, name: "George", vin: "33133313331333133")
    end

    it "is an instance of Driver" do
      @driver.must_be_kind_of RideShare::Driver
    end

    it "throws an argument error with a bad ID value" do
      proc{ RideShare::Driver.new(id: 0, name: "George", vin: "33133313331333133")}.must_raise ArgumentError
    end

    it "throws an argument error with a bad VIN value" do
      proc{ RideShare::Driver.new(id: 100, name: "George", vin: "")}.must_raise ArgumentError
      proc{ RideShare::Driver.new(id: 100, name: "George", vin: "33133313331333133extranums")}.must_raise ArgumentError
    end

    it "sets trips to an empty array if not provided" do
      @driver.trips.must_be_kind_of Array
      @driver.trips.length.must_equal 0
    end

    it "is set up for specific attributes and data types" do
      [:id, :name, :vehicle_id, :status].each do |prop|
        @driver.must_respond_to prop
      end

      @driver.id.must_be_kind_of Integer
      @driver.name.must_be_kind_of String
      @driver.vehicle_id.must_be_kind_of String
      @driver.status.must_be_kind_of Symbol
    end
  end

  describe "add trip method" do
    before do
      pass = RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640")
      @driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
      @trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: pass, start_time: Time.parse("2015-05-20 12:14:00"), end_time: Time.parse("2015-05-20 12:39:00"), rating: 5})
    end

    it "throws an argument error if trip is not provided" do
      proc{ @driver.add_trip(1) }.must_raise ArgumentError
    end

    it "increases the trip count by one" do
      previous = @driver.trips.length
      @driver.add_trip(@trip)
      @driver.trips.length.must_equal previous + 1
    end
  end

  describe "average_rating method" do
    before do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
      trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: nil, start_time: @start_time, end_time: @end_time, rating: 5})
      @driver.add_trip(trip)
    end

    it "returns a float" do
      @driver.average_rating.must_be_kind_of Float
    end

    it "returns a float within range of 1.0 to 5.0" do
      average = @driver.average_rating
      average.must_be :>=, 1.0
      average.must_be :<=, 5.0
    end

    it "returns zero if no trips" do
      driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
      driver.average_rating.must_equal 0
    end
  end

  describe "driver's total revenue" do
    before do
      @trip_1 = RideShare::Trip.new(id: 1, driver: 1, passenger: 54, start_time: Time.parse('2016-04-05T14:01:00+00:00'), end_time: Time.parse('2016-04-05T14:09:00+00:00'), cost: 17.39, rating: 3)
      @trip_2 = RideShare::Trip.new(id: 122, driver: 1, passenger: 247, start_time: Time.parse('2015-12-24T04:57:00+00:00'), end_time: Time.parse('2015-12-24T04:57:00+00:00'), cost: 13.11, rating: 5)
      @driver = RideShare::Driver.new(id: 1, name: "Bernardo Prosacco", vin: "WBWSS52P9NEYLVDE9", status: :UNAVAILABLE, trips: [])
    end

    it "calculates that driver's total revenue" do
      @driver.add_trip(@trip_1)
      @driver.add_trip(@trip_2)

      @driver.driver_total_revenue.must_equal (17.39 + 13.11 - 1.65) * 0.8
    end

    it "returns 0 if there are no trips for driver" do
      @driver.driver_total_revenue.must_equal 0
    end

  end
  describe "Average revenue per hour" do
    it "calculates the driver's average revenue per hour" do
      @driver.add_trip(@trip_1)
      @driver.add_trip(@trip_2)

      @driver.ave_rev_per_hr.must_equal ((17.39 + 13.11 - 1.65) * 0.8 / 2).round(2)
    end
  end
end
