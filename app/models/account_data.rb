class AccountData
  attr_reader :file_name, :streaming_history

  def inspect = "AccountData(#{@file_name})"

  def self.index
    Dir.glob('data/*.zip').map { File.basename(_1).chomp('.zip') }
  end

  def self.find(file_name) = new(file_name)

  def initialize(file_name)
    @file_name = file_name
    @streaming_history = AccountDataFile.new(file_name).get_streaming_history
  end

  def country_data = @cd ||= JSON.parse(File.read("app/models/country_data.json"))

  def by_country
    @streaming_history
      .map { _1['conn_country'] }
      .tally
      .compact_blank
      .map { ["#{country_data[_1]} (#{_2})", _2] }
      .sort_by { -_2 }
      .to_h
  end

  def by_day
    @by_day ||= @streaming_history
      .map { _1['ts'].to_date }
      .tally
      .sort
  end

  def accumulated_minutes
    as_hash = @streaming_history
      .group_by { _1['ts'].to_date.beginning_of_year }
      .transform_values { |vs| vs.sum { _1['ms_played'].to_f / 1000 / 60 } }
  end

  def top_artists_by_rank
    @streaming_history
      .group_by { _1['ts'].to_date.beginning_of_year }
      .transform_values do |vs|
         vs
          .group_by { _1['master_metadata_album_artist_name'] }
          .transform_values { |vs| vs.sum { _1['ms_played'].to_f / 1000 / 60 } }
          .sort_by { -_2 }
          .each_with_index
          .map { |e, i| [e[0], i] }
          .first(30)
        end
        .flat_map do |month, artists_with_rank|
          artists_with_rank.map { [month, *_1] }
        end
        .group_by { _1[1] }
        .transform_values { |vs| vs.map { [_1[0], _1[2]] } }
        .map { { name: _1, data: _2 } }
  end
end
