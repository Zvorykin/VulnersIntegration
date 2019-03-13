require 'typhoeus'

module VulnersRequest
  URL = 'http://vulners.com/api/v3/archive/collection'.freeze

  def get_vulners_archive(type)
    @response = Typhoeus.get(URL, params: { type: type })

    unless valid_content_type_header?
      raise "skipping #{type}: content-type - #{@response.headers['content-type']}"
    end

    unless valid_response_code?
      raise "skipping #{type}: status #{@response.response_code} - #{@response.status_message}"
    end

    @response.response_body
  end

  private

  def valid_content_type_header?
    @response.headers['content-type'] == 'application/x-zip-compressed'
  end

  def valid_response_code?
    @response.response_code == 200
  end
end
