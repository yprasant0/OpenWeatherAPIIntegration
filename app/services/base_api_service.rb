class ApiService
  include HTTParty

  def self.fetch_data(url, method: :get, options: {}, attempt: 1, max_attempts: 3)
    raise ArgumentError, 'Invalid HTTP method' unless [:get, :post, :put, :delete].include?(method)

    response = send(method, url, options)

    if response.success?
      response
    elsif attempt < max_attempts
      exponential_backoff(attempt)
      fetch_data(url, method: method, options: options, attempt: attempt + 1, max_attempts: max_attempts)
    else
      Rails.logger.error("Failed to fetch #{url} after #{attempt} attempts. Error: #{response.code}, Body: #{response.body}")
      raise FetchDataError.new(url, attempt, response.code, response.body)
    end
  rescue FetchDataError => e
    Rails.logger.error("FetchDataError handled at a higher level")
    nil
  rescue StandardError => e
    Rails.logger.error("Unexpected error while fetching #{url}: #{e}")
    nil
  end

  private

  def self.check_rate_limit(headers)
    remaining = headers['x-ratelimit-remaining']&.to_i
    reset = headers['x-ratelimit-reset']&.to_i

    # Notify if approaching the rate limit
    if remaining <= 1 && reset.positive?
      wait_time = [reset - Time.now.to_i, 0].max + 1
      Rails.logger.warn("Approaching rate limit, only #{remaining} requests left. Rate limit resets in #{wait_time} seconds.")
    end
  end

  def self.exponential_backoff(attempt)
    sleep_time = 2 ** attempt
    Rails.logger.info("Retrying in #{sleep_time} seconds...")
    sleep(sleep_time)
  end
end

