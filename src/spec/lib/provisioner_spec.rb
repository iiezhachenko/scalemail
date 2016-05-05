require 'rspec'
require_relative '../../lib/provisioner'

describe 'CLI Interaction' do
  before do
    $stdout = StringIO.new
    $stderr = StringIO.new
  end
  after(:all) do
    $stdout = STDOUT
    $stderr = STDERR
  end

  it 'should print timestamped message in STDOUT' do
    # TODO: fix
    # Provisioner.new(nil).formatted_log_to_stdout('prefix', 'string')
    # expect($stdout.string).to match(/\d{2}:\d{2} prefix string/)
  end
  it 'should print message without timestamp in STDOUT' do
    #TODO: fix
    #Provisioner.new(nil).formatted_log_to_stdout('prefix', 'string', false)
    #expect($stdout.string).to match(/prefix string/)
  end

end