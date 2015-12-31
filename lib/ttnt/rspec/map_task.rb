require 'rake'
require 'rake/tasklib'
require 'rspec/support'

module TTNT
  module RSpec
    class MapTask < ::RSpec::Core::RakeTask
      TTNT_OPTS = '--require ttnt/formatters/rspec --format TTNT::RSpec::Formatter '.freeze
      alias_method :orig_rspec_opts, :rspec_opts
      def rspec_opts
        "#{TNTT_OPTS} #{orig_rspec_opts}"
      end
    end

    class RemapTask < MapTask
      alias_method :orig_rspec_opts, :rspec_opts


    end

  end
end
