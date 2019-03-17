require 'nats/client'

NATS.start do
  LOG_COUNT = ENV['LOG_COUNT_EACH'].to_i || 100
  @count = 0

  NATS.subscribe('vulners.data') do |msg|
    @count += 1
    Rails.logger.info "NATS: get #{count} records" if (count % LOG_COUNT).zero?



    # puts "Msg received : '#{msg}'"
  end

  NATS.stop
end