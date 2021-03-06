require_relative 'spec_helper'

describe "Passenger class" do

  describe "Passenger instantiation" do
    before do
      @passenger = RideShare::Passenger.new({id: 1, name: "Smithy", phone: "353-533-5334"})
    end

    it "is an instance of Passenger" do
      @passenger.must_be_kind_of RideShare::Passenger
    end

    it "throws an argument error with a bad ID value" do
      proc{ RideShare::Passenger.new(id: 0, name: "Smithy")}.must_raise ArgumentError
    end

    it "sets trips to an empty array if not provided" do
      @passenger.trips.must_be_kind_of Array
      @passenger.trips.length.must_equal 0
    end

    it "is set up for specific attributes and data types" do
      [:id, :name, :phone_number, :trips].each do |prop|
        @passenger.must_respond_to prop
      end

      @passenger.id.must_be_kind_of Integer
      @passenger.name.must_be_kind_of String
      @passenger.phone_number.must_be_kind_of String
      @passenger.trips.must_be_kind_of Array
    end
  end


  describe "trips property" do
    before do
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723", trips: [])
      trip = RideShare::Trip.new({id: 8, driver: nil, passenger: @passenger, start_time: @start_time, end_time: @end_time, rating: 5})

      @passenger.add_trip(trip)
    end

    it "each item in array is a Trip instance" do
      @passenger.trips.each do |trip|
        trip.must_be_kind_of RideShare::Trip
      end
    end

    it "all Trips must have the same Passenger id" do
      @passenger.trips.each do |trip|
        trip.passenger.id.must_equal 9
      end
    end
  end

  describe "get_drivers method" do
    before do
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")
      driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
      trip = RideShare::Trip.new({id: 8, driver: driver, passenger: @passenger, start_time: @start_time, end_time: @end_time, rating: 5})

      @passenger.add_trip(trip)
    end

    it "returns an array" do
      drivers = @passenger.get_drivers
      drivers.must_be_kind_of Array
      drivers.length.must_equal 1
    end

    it "all items in array are Driver instances" do
      @passenger.get_drivers.each do |driver|
        driver.must_be_kind_of RideShare::Driver
      end
    end
  end

  describe "Total amount of money passenger spent on all trips" do

    it 'returns the total amount of money spent by passenger on all trips' do

      driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")

      trip = RideShare::Trip.new({id: 8, driver: driver, start_time: @start_time, end_time: @end_time, cost: 17.39, rating: 5})

      passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")

      passenger.add_trip(trip)
      passenger.total_money_spent.must_equal trip.cost

    end
  end


  describe "Amount of time spent on all trips total" do

    it "Calculates the amount of time rider spent on trips" do

      start_time = Time.parse("2016-08-08T16:01:00+00:00")
      end_time = Time.parse("2016-08-08T16:37:00+00:00")

      driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")

      trip = RideShare::Trip.new({id: 8, driver: driver, date: "2016-08-08", cost: 17.39, rating: 5, start_time: start_time, end_time: end_time })

      passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")

      passenger.add_trip(trip)


      duration_of_trip = (end_time.to_f - start_time.to_f)

      passenger.time_spent.must_equal duration_of_trip

    end
  end


end
