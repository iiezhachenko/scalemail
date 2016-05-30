require_relative '../support/env'

When(/^I start application "([^"]*)" command  with "([^"]*)" config$/) \
do |command, config_file|
  config_path = File.absolute_path config_file
  step %(I run `scalemail -m #{config_path} #{command}`)
end
