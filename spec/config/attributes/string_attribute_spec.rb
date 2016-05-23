require_relative '../../../lib/config/attributes/string_attribute.rb'
require_relative '../shared_examples.rb'

describe StringAttribute do
  subject { StringAttribute }
  it_behaves_like 'Attribute', :string_attribute
  context '#to_s' do
    include_examples "value can't be empty", :string_attribute, ''
    context 'value not String' do
      let(:fixture) { build(:string_attribute, value: [1, 2]) }
      raise_test 'value', 'should be String'
    end
    let(:fixture) { build :string_attribute }
    include_examples 'test #to_s string', '--name value'
  end
end
