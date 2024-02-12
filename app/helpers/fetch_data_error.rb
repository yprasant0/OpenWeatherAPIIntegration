class FetchDataError < StandardError
  attr_reader :url, :attempt, :response_code, :response_body

  def initialize(url, attempt, response_code, response_body)
    super("Failed to fetch #{url} after #{attempt} attempts. Error: #{response_code}, Body: #{response_body}")
    @url = url
    @attempt = attempt
    @response_code = response_code
    @response_body = response_body
  end
end

