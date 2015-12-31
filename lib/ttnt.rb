require 'ttnt/version'
require 'ttnt/test_selector'
# Test This, Not That!
#
# See {file:README.md} for more details.
module TTNT
  def self.select_tests(expanded_file_list, target_sha = ENV['TARGET_SHA'], repo = nil)
    ts = TTNT::TestSelector.new(repo, target_sha, expanded_file_list)
    ts.select_tests!
  end
end
