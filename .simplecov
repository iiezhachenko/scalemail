require 'cadre/simplecov'

# SimpleCov.start 'rails' do #if, you know: Rails.
SimpleCov.start do
  SimpleCov.formatters = [
    SimpleCov::Formatter::HTMLFormatter,
    Cadre::SimpleCov::VimFormatter
  ]
  add_filter 'features/'
  add_filter 'spec/'
end
