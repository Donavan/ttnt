require 'test_helper'
require 'ttnt/metadata'

class MetaDataTest < TTNT::TestCase::FizzBuzz
  def setup
    @storage_file =  File.join @repo.workdir , '.ttnt'
    File.delete(@storage_file) if File.exists? @storage_file

    @metadata = TTNT::MetaData.new(@repo)
    @name = 'anchored_sha'
    @value = 'abcdef'
  end

  def test_get_metadata
    File.write(@storage_file, { 'meta' => { @name => @value} }.to_json)
    assert @metadata[@name].nil?, '#get should not read from file.'
    @metadata.read!
    assert_equal @value, @metadata[@name]
  end

  def test_write_metadata
    @metadata[@name] = @value
    @metadata.write!
    expected = { 'meta' => { @name => @value } }
    assert_equal expected, JSON.parse(File.read(@storage_file))
  end
end
