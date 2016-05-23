require_relative '../../../lib/config/attributes/attribute.rb'
require_relative '../shared_examples.rb'

describe Attribute do
  subject { Attribute }
  include_examples 'Attribute', :attribute
  msg = 'This is a generic class. Use specialized child instead'
  let(:fixture) { build :attribute }
  it 'throws NotImplementedException when #to_s called' do
    expect { fixture.to_s }.to raise_error(NotImplementedError, msg)
  end
end
