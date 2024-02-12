require 'rails_helper'

RSpec.describe AirQuality, type: :model do
  describe 'Validations' do
    it 'is valid with valid attributes' do
      location = FactoryBot.create(:location) # Ensure you have a location factory
      air_quality = AirQuality.new(aqi: 50, measured_at: Time.zone.now, location: location)
      expect(air_quality).to be_valid
    end
  end

  it 'is invalid without an aqi' do
    air_quality = FactoryBot.build(:air_quality, aqi: nil)
    expect(air_quality).not_to be_valid
    expect(air_quality.errors[:aqi]).to include("can't be blank")
  end

  it 'is invalid without a measured_at' do
    air_quality = FactoryBot.build(:air_quality, measured_at: nil)
    expect(air_quality).not_to be_valid
    expect(air_quality.errors[:measured_at]).to include("can't be blank")
  end

  describe 'Associations' do
    it 'belongs to a location' do
      assoc = described_class.reflect_on_association(:location)
      expect(assoc.macro).to eq :belongs_to
    end
  end

  describe "Scopes" do
    # Setup test data
    before do
      @location1 = create(:location, name: "City Park", state: "New State")
      @location2 = create(:location, name: "Riverside", state: "Old State")

      # Create air qualities for location1
      create(:air_quality, aqi: 50, measured_at: "2022-01-10", location: @location1)
      create(:air_quality, aqi: 150, measured_at: "2022-01-20", location: @location1)

      # Create air qualities for location2
      create(:air_quality, aqi: 200, measured_at: "2022-02-15", location: @location2)
      create(:air_quality, aqi: 100, measured_at: "2022-02-25", location: @location2)
    end

    it "calculates average AQI per month per location correctly" do
      results = AirQuality.average_aqi_per_month_per_location.to_a

      expect(results.size).to eq(2) # Since we expect results for 2 different groups
      # For the first result, check attributes and average
      expect(results[0].location_name).to eq("City Park")
      expect(results[0].year).to eq(2022)
      expect(results[0].month).to eq(1)
      expect(results[0].average_aqi).to be_within(0.01).of(100) # Adjust based on expected average

      # For the second result, check attributes and average
      expect(results[1].location_name).to eq("Riverside")
      expect(results[1].year).to eq(2022)
      expect(results[1].month).to eq(2)
      expect(results[1].average_aqi).to be_within(0.01).of(150) # Adjust based on expected average
    end

    it "calculates average AQI per location correctly" do
      results = AirQuality.average_aqi_per_location
      expect(results.map(&:location_name).sort).to eq(["City Park", "Riverside"])
      expect(results.map(&:average_aqi)).to all(be_a(Numeric))
    end

    it "calculates average AQI per state correctly" do
      results = AirQuality.average_aqi_per_state
      expect(results.map(&:state).sort).to eq(["New State", "Old State"])
      expect(results.map(&:average_aqi)).to all(be_a(Numeric))
    end
  end
end
