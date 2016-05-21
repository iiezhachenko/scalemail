require_relative '../../lib/config/array_property.rb'
require_relative './shared_examples.rb'

describe ArrayProperty do
  subject { ArrayProperty }
  it_behaves_like 'Property', :array_property
  context '#to_s' do
    include_examples "value can't be empty", :array_property, []
    context 'value not Array' do
      let(:fixture) { build(:array_property, value: 'string') }
      raise_test 'value', 'should be Array'
    end
    let(:fixture) { build(:array_property, value: [1, 2]) }
    include_examples 'test #to_s string', '--name=1 --name=2'
  end
end
