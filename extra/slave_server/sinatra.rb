require 'sinatra/base'
require 'zip'

require './request.rb'

require 'yajl'

require 'json/streamer'

class App < Sinatra::Base
  include VulnersRequest

  set :server, 'thin'
  set :logging, true

  get '/' do
    'hello world'
  end

  get '/get_vulners_data' do
    parser = Yajl::Parser.new(symbolize_keys: true)

    stream do |out|
      zip_buffer = get_vulners_archive('drupal')


      unless zip_buffer.nil?
        # Zip::File.open_buffer(zip_buffer) do |zip|
        Zip::File.open('cve.zip') do |zip|
          zip.each do |entry|
            puts entry.name

            json_stream = entry.get_input_stream
            streamer = Json::Streamer.parser(file_io: json_stream, chunk_size: 100)

            streamer.get(nesting_level:1) do |object|
              out << object
            end

          end
        end
      end

    rescue => e
      logger.warn e.message
    end
  end
end

App.run!