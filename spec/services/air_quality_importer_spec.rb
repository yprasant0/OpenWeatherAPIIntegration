require 'rails_helper'

RSpec.describe AirQualityImporter do
  describe '.import_all_locations' do
    let!(:location) { FactoryBot.create(:location, latitude: 40.712776, longitude: -74.005974) }
    let(:api_response) { { "list" => [{ "main" => { "aqi" => 3 }, "components" => { "pm2_5" => 12.34, "pm10" => 55.76, "co" => 0.004, "so2" => 0.005, "no2" => 0.02, "o3" => 0.007 }, "dt" => 1708398179 }] }.to_json }

    before do
      allow(AirQualityService).to receive(:fetch_air_quality).with(location.latitude, location.longitude).and_return(double(body: api_response, parsed_response: JSON.parse(api_response)))
    end

    it 'successfully imports air quality data for all locations' do
      expect { described_class.import_all_locations }.to change { location.air_qualities.count }.by(1)
      air_quality = location.air_qualities.last

      expect(air_quality.aqi).to eq(3)
      expect(air_quality.pm2_5).to eq(12.34)
      expect(air_quality.pm10).to eq(55.76)
      expect(air_quality.co).to eq(0.004)
      expect(air_quality.so2).to eq(0.005)
      expect(air_quality.no2).to eq(0.02)
      expect(air_quality.o3).to eq(0.007)
      expect(air_quality.measured_at).to eq(Time.at(1708398179).to_datetime)
    end

    context 'when the API request fails' do
      before do
        allow(AirQualityService).to receive(:fetch_air_quality).and_return(nil)
      end

      it 'logs the failure and does not create an air quality record' do
        expect(Rails.logger).to receive(:error).with(/Failed to fetch air quality for/)
        expect { described_class.import_all_locations }.not_to change { location.air_qualities.count }
      end
    end

    context 'when there is a parsing error' do
      let(:invalid_api_response) { { "invalid" => "data" }.to_json }

      before do
        allow(AirQualityService).to receive(:fetch_air_quality).and_return(double(body: invalid_api_response, parsed_response: JSON.parse(invalid_api_response)))
      end

      it 'logs the parsing error and does not create an air quality record' do
        expect(Rails.logger).to receive(:error).with(/Error parsing air quality response/)
        expect { described_class.import_all_locations }.not_to change { location.air_qualities.count }
      end
    end

    context 'when there is a record invalid error' do
      before do
        allow(AirQualityService).to receive(:fetch_air_quality).with(location.latitude, location.longitude).and_return(double(body: api_response, parsed_response: JSON.parse(api_response)))
        allow_any_instance_of(AirQuality).to receive(:save!).and_raise(ActiveRecord::RecordInvalid)
      end

      it 'logs the failure and does not create an air quality record' do
        expect(Rails.logger).to receive(:error).with(/Error saving air quality data for/)
        expect { described_class.import_all_locations }.not_to change { location.air_qualities.count }
      end
    end
  end
end
