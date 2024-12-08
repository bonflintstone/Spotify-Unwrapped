require 'zip'

class AccountDataFile
  def initialize(file_name)
    @file_name = file_name
  end

  def get_streaming_history
    result = []

    Zip::File.open("data/#{@file_name}.zip") do |entries|
      entries.each do |entry|
        next unless entry.name.match? /StreamingHistory_music.*\.json/

        result.push(*JSON.parse(entry.get_input_stream.read))
      end
    end

    result
  end
end
