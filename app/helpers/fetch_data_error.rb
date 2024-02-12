class FetchDataError < StandardError
  attr_reader :url, :attempts, :response_code, :response_body

  def initialize(url, attempts, response_code, response_body)
    @url = url
    @attempts = attempts
    @response_code = response_code
    @response_body = response_body
    super("Failed to fetch #{url} after #{attempts} attempts. Error: #{response_code}, Body: #{response_body}")
  end
end
