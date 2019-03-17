require 'typhoeus'

module VulnersService
  class << self
    def start_integration
      request = Typhoeus::Request.new('localhost:4567/get_vulners_data')
      count = 0

      request.on_headers do |response|
        raise "Request failed - #{response.code} #{response.status}" if response.code != 200
      end

      request.on_body do |chunk|
        count += 1

        Rails.logger.info "get #{count} records" if (count % 10).zero?
        # downloaded_file.write(chunk)
      end

      request.on_complete do
        Rails.logger.info "proceed #{count} records total"
      end

      request.run
    end
  end
end