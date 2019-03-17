require 'nats/client'
require 'yajl/http_stream'

module VulnersService
  class << self
    LOG_COUNT = ENV['LOG_COUNT_EACH'].to_i || 10

    def start_integration
      count = 0
      url = 'http://localhost:4567/get_vulners_data'

      Yajl::HttpStream.get(url, symbolize_keys: true) do |hash|
        count += 1
        Rails.logger.info "get #{count} records" if (count % LOG_COUNT).zero?

        # NATS.publish('vulners.data', chunk)
      end

      Rails.logger.info "proceed #{count} records total"
    end
  end
end