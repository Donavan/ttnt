require 'test_helper'
require 'ttnt/storage'

class StorageTest < TTNT::TestCase::FizzBuzz
  def setup
    @storage_file =  File.join @repo.workdir , '.ttnt'
    File.delete(@storage_file) if File.exists? @storage_file

    @section = 'test'
    @storage = TTNT::Storage.new(@repo)
    @data = { 'a' => 1, 'b' => 2 }
  end

  def test_read_storage
    File.write(@storage_file, { @section => @data }.to_json)
    assert_equal @data, @storage.read(@section)
  end

  def test_read_storage_from_history
    @storage.write!(@section, @data)
    git_commit_am('Add data to storage file')
    sha = @repo.head.target_id
    new_data = { 'c' => 3 }
    @storage.write!(@section, new_data) # write to a file in working tree
    history_storage = TTNT::Storage.new(@repo, sha)
    assert !history_storage.read(@section).key?('c'),
      'History storage should not contain data from current working directory.'
  end

  def test_read_absent_storage_from_history
    git_rm_and_commit("#{@repo.workdir}/.ttnt", 'Remove .ttnt file')
    storage = TTNT::Storage.new(@repo, @repo.head.target_id)
    assert_equal Hash.new, storage.read(@section)
  end

  def test_write_storage
    @storage.write!(@section, @data)
    assert File.exist?(@storage_file), 'Storage file should be created.'
    assert_equal @data, JSON.parse(File.read(@storage_file))[@section]
  end

  def test_cannot_write_to_history_storage
    sha = @repo.head.target_id
    history_storage = TTNT::Storage.new(@repo, sha)
    assert_raises { history_storage.write!(@section, @data) }
  end

  def test_storage_file_resides_with_rakefile
    @storage.write!(@section, @data)
    subdir = "#{@repo.workdir}/tmp"
    Dir.mkdir(subdir)
    rakefiles = ["#{@repo.workdir}/Rakefile", "#{subdir}/Rakefile"]
    FileUtils.copy rakefiles[0], rakefiles[1]

    TTNT.root_dir = nil
    load_rakefile(rakefiles)

    Dir.chdir(subdir) do
      storage = TTNT::Storage.new(@repo)
      assert_equal Hash.new, storage.read(@section)

      TTNT.root_dir = nil
      File.delete(rakefiles[1])
      assert_equal @data, storage.read(@section)
    end
  end
end
