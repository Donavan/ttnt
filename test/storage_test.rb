require 'test_helper'
require 'ttnt/storage'

class StorageTest < TTNT::TestCase
  def setup
    @storage_file = "#{@repo.workdir}/.ttnt"
    FileUtils.rm_rf(@storage_file)

    @section = 'test'
    @storage = TTNT::Storage.new(@repo)
    @data = { 'a' => 1, 'b' => 2 }
  end

  def test_read_storage
    File.write(@storage_file, { @section => @data }.to_json)
    assert_equal @data, @storage.read(@section)
  end

  def test_write_storage
    @storage.write!(@section, @data)
    assert File.exist?(@storage_file), 'Storage file should be created.'
    assert_equal @data, JSON.parse(File.read(@storage_file))[@section]
  end
end