require 'rails_helper'

RSpec.describe GeocodingService do

  describe GeocodingService do
    describe '.geocode' do
      it 'successfully geocodes a location', :vcr do
        VCR.use_cassette('geocode_london') do
          query_params = { q: 'New York' }
          response = described_class.geocode(query_params)
          expect(response).not_to be_nil
          expect(response['lat']).to eq(40.7127281)
          expect(response['lon']).to eq(-74.0060152)
          expect(response['country']).to eq('US')
          expect(response['name']).to eq('New York County')
          expect(response['state']).to eq('New York')
        end
      end
    end
  end

  describe GeocodingService, :vcr do
    it 'handles API errors gracefully' do
      VCR.use_cassette('geocode_api_error') do
        query_params = { q: 'InvalidLocation' }
        expect(described_class.geocode(query_params)).to be_nil
      end
    end
  end

end
