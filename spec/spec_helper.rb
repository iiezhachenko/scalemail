require 'cadre/rspec3'
require 'simplecov'

SimpleCov.command_name 'tests:unit'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  if config.formatters.empty?
    # config.add_formatter(:progress)
    # but do consider:
    config.add_formatter(Cadre::RSpec3::TrueFeelingsFormatter)
  end
  config.add_formatter(Cadre::RSpec3::NotifyOnCompleteFormatter)
  config.add_formatter(Cadre::RSpec3::QuickfixFormatter)
end
