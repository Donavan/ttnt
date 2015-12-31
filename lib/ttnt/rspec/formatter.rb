RSpec::Support.require_rspec_core 'formatters/base_formatter'
require 'ttnt/test_to_code_mapping'
require 'rugged'

module TTNT
  module RSpec
    # @private
    class Formatter < ::RSpec::Core::Formatters::BaseFormatter
      ::RSpec::Core::Formatters.register self, :example_passed, :example_failed, :close

      def initialize(output)
        super
        @tests = []
        ENV['ANCHOR_TASK'] = '1'
        @repo = Rugged::Repository.discover(Dir.pwd)
        @mapping = TTNT::TestToCodeMapping.new(@repo)
      end

      def example_passed(notification)
        record_example notification.example
      end

      def example_failed(notification)
        record_example notification.example
      end

      def record_example(example)
        @mapping.append_from_coverage("RSPEC:#{example.id}", SimpleCov.result.original_result)
        @tests << example.id
      end

      def close(_example)
        @mapping.write!
      end
    end
  end
end
