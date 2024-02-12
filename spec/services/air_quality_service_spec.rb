require 'rails_helper'

RSpec.describe AirQualityService do
  describe '.fetch_air_quality' do
    let(:latitude) { 40.712776 }
    let(:longitude) { -74.005974 }
    let(:base_uri) {described_class.base_uri}
    let(:end_point) { "/air_pollution" }
    let(:api_response) { { "data" => "some_air_quality_data" }.to_json }
    let(:api_key) { 'some_api_key' }

    before do
      allow(AirQualityService).to receive(:open_weather_api_key).and_return(api_key)
      stub_request(:get, "#{base_uri}#{end_point}")
        .with(query: hash_including({ lat: latitude.to_s, lon: longitude.to_s, appid: api_key }))
        .to_return(status: 200, body: api_response, headers: {})
    end

    it 'returns the air quality data' do
      response = AirQualityService.fetch_air_quality(latitude, longitude)
      expect(JSON.parse(response.body)["data"]).to eq("some_air_quality_data")
    end

    it 'logs the successful request' do
      expect(Rails.logger).not_to receive(:error)
      AirQualityService.fetch_air_quality(latitude, longitude)
    end

    it 'does not create a failed request record' do
      expect(FailedRequest).not_to receive(:create!)
      AirQualityService.fetch_air_quality(latitude, longitude)
    end
  end
end

