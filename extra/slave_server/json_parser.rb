require 'json/streamer'

module JsonParser
  LOG_COUNT = ENV['LOG_COUNT_EACH'].to_i || 100

  def parse_and_stream_json(stream, out)
    streamer = Json::Streamer.parser(file_io: stream, chunk_size: 1_000_000)
    start_rec_counter = @rec_counter

    streamer.get(nesting_level: 1) do |object|
      out << object.to_json
      @rec_counter += 1

      logger.info "SINATRA: #{@rec_counter} records was sent" \
        if (@rec_counter % 1_000).zero?
    end

    @rec_counter - start_rec_counter
  end
end
