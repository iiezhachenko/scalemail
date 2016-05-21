require_relative '../../lib/config/property.rb'
require_relative './shared_examples.rb'

describe Property do
  subject { Property }
  include_examples 'Property', :property
  msg = 'This is a generic class. Use specialized child instead'
  let(:fixture) { build :property }
  include_examples 'test #to_s string', msg
end
