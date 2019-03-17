require 'sinatra/base'

require './extra/slave_server/request.rb'
require './extra/slave_server/zip.rb'
require './extra/slave_server/vulners_types.rb'
require './extra/slave_server/json_parser.rb'

class SlaveServerApp < Sinatra::Base
  include VulnersRequest
  include ZipParser
  include VulnersTypes
  include JsonParser

  set :server, 'Puma'
  set :logging, true

  get '/' do
    'hello world'
  end

  get '/get_vulners_data' do
    start_time = Time.now
    logger.info '### integration started ###'

    headers['Content-Type'] = 'text/json'
    @rec_counter = 0

    stream do |out|
      VulnersTypes::TYPES.each do |type|
        logger.info "downloading report - #{type}"
        content = get_vulners_archive(type)

        logger.info "report #{type} downloaded - unzipping"
        file = get_file_from_zip(content)

        logger.info "starting to parse #{file.name}"
        file_rec_count = parse_and_stream_json(file.get_input_stream, out)

        logger.info "SINATRA: finished parsing #{file.name} - #{file_rec_count} items were sent"
        logger.info "SINATRA: #{@rec_counter} items were parsed and sent total"
      end

      log_execution_time(start_time)
    rescue => e
      logger.warn e.message
    end
  end

  private

  def log_execution_time(start_time)
    diff_time = (Time.now - start_time).to_i

    if diff_time > 60
      time_units = 'minutes'
      diff_time /= 60
    else
      time_units = 'seconds'
    end

    logger.info "### integration finished! it takes #{diff_time} #{time_units} ###"
  end
end

SlaveServerApp.run!