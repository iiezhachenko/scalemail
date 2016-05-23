require_relative '../../../lib/config/attributes/array_attribute.rb'
require_relative '../shared_examples.rb'

describe ArrayAttribute do
  subject { ArrayAttribute }
  it_behaves_like 'Attribute', :array_attribute
  context '#to_s' do
    include_examples "value can't be empty", :array_attribute, []
    context 'value not Array' do
      let(:fixture) { build(:array_attribute, value: 'string') }
      raise_test 'value', 'should be Array'
    end
    let(:fixture) { build(:array_attribute, value: [1, 2]) }
    include_examples 'test #to_s string', '--name=1 --name=2'
  end
end
