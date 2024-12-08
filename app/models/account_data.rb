class AccountData
  attr_reader :file_name, :streaming_history

  def self.index
    Dir.glob('data/*.zip').map { File.basename(_1).chomp('.zip') }
  end

  def self.find(file_name) = new(file_name)

  def initialize(file_name)
    @file_name = file_name
    @streaming_history = AccountDataFile.new(file_name).get_streaming_history
  end
end
