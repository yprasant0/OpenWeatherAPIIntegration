require 'rails_helper'

RSpec.describe HistoricalAirQualityService do
  describe '.fetch_and_store_history' do
    let(:location) { create(:location, latitude: 50, longitude: 50) }
    let(:base_uri) { described_class.base_uri }
    let(:end_point) { '/history' }
    let(:successful_response) { File.read('spec/fixtures/historical_air_quality.json') }

    before do
      allow(Location).to receive(:find_each).and_yield(location)
    end

    context 'when the API returns a successful response' do
      before do
        stub_request(:get, base_uri+end_point).to_return(body: successful_response, status: 200)
      end

      it 'parses and saves air quality data' do
        VCR.use_cassette('historical_air_quality_success') do
          expect { described_class.fetch_and_store_history }.to change(AirQuality, :count).by(3042)
          expect(FailedRequest.count).to eq(0)
        end
      end
    end

    context 'when the API returns a failure' do
      before do
        stub_request(:get, "#{base_uri}#{end_point}")
          .with(query: hash_including({lat: location.latitude.to_s, lon: location.longitude.to_s}))
          .to_return(status: 500, body: "Internal Server Error")
      end

      it 'raises a FetchDataError and logs the failure' do
        expect { described_class.fetch_and_store_history }.to raise_error(FetchDataError) do |error|
          expect(error.url).to eq("#{base_uri}#{end_point}")
          expect(error.response_code).to eq(500)
          expect(error.response_body).to include("Internal Server Error")
        end
      end
    end
  end
end
