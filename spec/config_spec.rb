require_relative '../lib/config'

def raise_test(test_obj, err, exception = RuntimeError)
  it "throws #{exception}" do
    expect { factory.to_s }.to \
      raise_error(exception, "Property #{test_obj} #{err}")
  end
end

shared_examples_for 'Property behavior' do |factory|
  let(:name) { 'name' }
  let(:value) { 'value' }
  it 'builds object when given both args' do
    prop = subject.new name, value
    expect(prop.name).to eq name
    expect(prop.value).to eq value
  end
  context "name isn't String" do
    let(:factory) { build(factory, name: nil) }
    raise_test 'name', 'should be String'
  end
  context 'name is empty' do
    let(:factory) { build(factory, name: '') }
    raise_test 'name', "can't be empty"
  end
  context 'value is empty' do
    let(:factory) { build(factory, value: nil) }
    raise_test 'value', "can't be empty"
  end
end

describe Property do
  subject { Property }
  context '#new' do
    include_examples 'Property behavior', :property
  end
end

describe StringProperty do
  subject { StringProperty }
  context '#new' do
    include_examples 'Property behavior', :string_property
    context 'value not String' do
      let(:factory) { build(:string_property, value: [1, 2]) }
      raise_test 'value', 'should be String'
    end
  end
end
