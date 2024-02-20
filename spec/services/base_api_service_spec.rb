require 'rails_helper'

RSpec.describe BaseApiService do
  describe 'fetching data' do
    let(:method) { :get }
    let(:options) { {} }

    context 'when the request initially fails but succeeds on retry' do
      let(:url) { 'http://api.openweathermap.org/test' }

      it 'retries the request and successfully fetches data' do
        # First request fails with a 500 Internal Server Error
        stub_request(method, url).to_return(
          { status: 500, body: "Internal Server Error" },
          { status: 200, body: "Success" } # Second request succeeds
        )

        expect(Rails.logger).to receive(:info).with("Retrying in 2 seconds...").ordered
        response = BaseApiService.fetch_data(url, method: method, options: options)

        # Verify that the successful response is correctly handled
        expect(response.body).to eq("Success")
      end
    end

    context 'when the request fails and exceeds the maximum number of retries' do
      let(:url) { 'http://api.openweathermap.org/fail' }
      let(:max_attempts) { 3 }
      let(:method) { :get }

      it 'retries the specified number of times then raises FetchDataError' do
        stub_request(method, url)
          .to_return(status: 500, body: "Internal Server Error").times(max_attempts)

        expect(BaseApiService).to receive(:sleep).exactly(max_attempts - 1).times
        expect {
          BaseApiService.fetch_data(url, method: method, options: {}, max_attempts: max_attempts)
        }.to raise_error(FetchDataError) do |error|
          expect(error.url).to eq(url)
          expect(error.attempt).to eq(max_attempts)
          expect(error.response_code).to eq(500)
          expect(error.response_body).to include("Internal Server Error")
        end
      end
    end

    context 'when an unexpected error occurs' do
      let(:url) { 'http://api.openweathermap.org' }

      it 'logs and re-raises unexpected errors' do
        allow(BaseApiService).to receive(:send).and_raise(StandardError.new("Network error"))
        expect(BaseApiService).to receive(:log_error).at_least(:once)

        expect {
          BaseApiService.fetch_data(url)
        }.to raise_error(StandardError, "Network error")
      end
    end

    context 'when the HTTP method is invalid' do
      let(:url) { 'http://api.openweathermap.org' }

      it 'raises an ArgumentError' do
        expect {
          BaseApiService.fetch_data(url, method: :invalid)
        }.to raise_error(ArgumentError, 'Invalid HTTP method')
      end
    end

    context 'when the response is successful' do
      let(:url) { 'http://api.openweathermap.org' }

      it 'returns the response' do
        stub_request(method, url).to_return(status: 200, body: "Success")

        response = BaseApiService.fetch_data(url, method: method, options: options)
        expect(response.body).to eq("Success")
      end
    end
  end
end
