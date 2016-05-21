require_relative '../../lib/config/bool_property.rb'
require_relative './shared_examples.rb'

describe BoolProperty do
  subject { BoolProperty }
  it_behaves_like 'Property', :bool_property
  context '#to_s' do
    context 'value not Boolean' do
      let(:fixture) { build(:bool_property, value: [1, 2]) }
      raise_test 'value', 'should be Boolean'
    end
    context 'value is true' do
      let(:fixture) { build(:bool_property, value: true) }
      include_examples 'test #to_s string', '--name'
    end
    context 'value is false' do
      let(:fixture) { build(:bool_property, value: false) }
      include_examples 'test #to_s string', ''
    end
  end
end
