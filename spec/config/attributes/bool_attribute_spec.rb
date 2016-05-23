require_relative '../../../lib/config/attributes/bool_attribute.rb'
require_relative '../shared_examples.rb'

describe BoolAttribute do
  subject { BoolAttribute }
  it_behaves_like 'Attribute', :bool_attribute
  context '#to_s' do
    context 'value not Boolean' do
      let(:fixture) { build(:bool_attribute, value: [1, 2]) }
      raise_test 'value', 'should be Boolean'
    end
    context 'value is true' do
      let(:fixture) { build(:bool_attribute, value: true) }
      include_examples 'test #to_s string', '--name'
    end
    context 'value is false' do
      let(:fixture) { build(:bool_attribute, value: false) }
      include_examples 'test #to_s string', ''
    end
  end
end
