class BaseApiService
  include HTTParty

  def self.fetch_data(url, method: :get, options: {}, attempt: 1, max_attempts: 3)
    validate_http_method!(method)
    response = send(method, url, options)
    return response if response.success?

    handle_error(response, url, attempt, method, options, max_attempts)
  # Ensure that all errors, including handled ones, are re-raised for external management.
  rescue StandardError => e
    handle_unexpected_error(e, url)
    raise e
  end

  private

  def self.handle_error(response, url, attempt, method, options, max_attempts)
    if attempt < max_attempts
      exponential_backoff(attempt)
      fetch_data(url, method: method, options: options, attempt: attempt + 1, max_attempts: max_attempts)
    else
      log_and_raise_fetch_error(response, url, attempt)
    end
  end

  def self.handle_unexpected_error(error, url)
    log_error("Unexpected error while fetching #{url}: #{error.message}", error.backtrace)
  end

  def self.log_and_raise_fetch_error(response, url, attempt)
    error_message = "Failed to fetch #{url} after #{attempt} attempts. Error: #{response.code}, Body: #{response.body}"
    log_error(error_message)
    raise FetchDataError.new(url, attempt, response.code, response.body)
  end

  def self.validate_http_method!(method)
    valid_methods = [:get, :post, :put, :delete]
    raise ArgumentError, 'Invalid HTTP method' unless valid_methods.include?(method)
  end

  def self.log_error(message, backtrace = nil)
    Rails.logger.error(message)
    Rails.logger.error(backtrace.join("\n")) if backtrace
  end

  def self.exponential_backoff(attempt)
    sleep_time = 2 ** attempt
    Rails.logger.info("Retrying in #{sleep_time} seconds...")
    sleep(sleep_time)
  end
end
