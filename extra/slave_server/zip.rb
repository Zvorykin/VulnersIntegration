require 'zip'

module ZipParser
  def get_file_from_zip(buffer)
    # Zip::File.open('cve.json.zip') do |zip|
    Zip::File.open_buffer(buffer) do |zip|
      return zip.first
    end
  end
end
