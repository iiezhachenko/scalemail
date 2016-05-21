require_relative '../../lib/config/string_property.rb'
require_relative './shared_examples.rb'

describe StringProperty do
  subject { StringProperty }
  it_behaves_like 'Property', :string_property
  context '#to_s' do
    include_examples "value can't be empty", :string_property, ''
    context 'value not String' do
      let(:fixture) { build(:string_property, value: [1, 2]) }
      raise_test 'value', 'should be String'
    end
    let(:fixture) { build :string_property }
    include_examples 'test #to_s string', '--name value'
  end
end
