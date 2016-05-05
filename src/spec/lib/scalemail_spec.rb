require 'rspec'
require_relative '../../lib/scalemail'
require_relative '../spec_helper'


describe Scalemail do

  #
  # it 'raises error if configuration file cannot be readed' do
  #   begin
  #     Scalemail.new(%w(-m fakefile))
  #   rescue SystemExit
  #     expect($stderr.string).to match("Can't read Docker Machine configuration file: fakefile")
  #   end
  # end
  # it 'shows usage banner if no options provided' do
  #
  #
  # end
  # it 'shows usage banner if -h key provided' do
  #   begin
  #     Scalemail.new(%w(-h))
  #   rescue SystemExit
  #     expect($stdout.string).to match(@banner_message)
  #   end
  # end
  # it 'shows usage banner if --help key provided' do
  #   begin
  #     Scalemail.new(%w(--help))
  #   rescue SystemExit
  #     expect($stdout.string).to match(@banner_message)
  #   end
  # end
end
