require_relative '../lib/config'

def raise_test(test_obj, err, exception = RuntimeError)
  it "throws #{exception}" do
    expect { fixture.to_s }.to \
      raise_error(exception, "Property #{test_obj} #{err}")
  end
end

def test_to_s(expected_msg)
  it 'should return string for usage with Docker Machine' do
    expect(fixture.to_s).to be == expected_msg
  end
end

shared_examples_for 'Property' do |factory|
  let(:fixture) { build factory }
  context '#new' do
    it 'builds object when given name and value' do
      name = fixture.name
      value = fixture.value
      prop = subject.new name, value
      expect(prop.name).to eq name
      expect(prop.value).to eq value
    end
  end
  context '#to_s when' do
    context "name isn't String" do
      let(:fixture) { build(factory, name: nil) }
      raise_test 'name', 'should be String'
    end
    context 'name is empty' do
      let(:fixture) { build(factory, name: '') }
      raise_test 'name', "can't be empty"
    end
  end
end

shared_examples_for "value can't be empty" do |factory, value|
  context 'value is empty' do
    let(:fixture) { build(factory, value: value) }
    raise_test 'value', "can't be empty"
  end
end

shared_examples_for 'test #to_s string' do |msg|
  context 'attributes are valid' do
    test_to_s msg
  end
end

describe Property do
  subject { Property }
  include_examples 'Property', :property
  msg = 'This is a generic class. Use specialized child instead'
  let(:fixture) { build :property }
  include_examples 'test #to_s string', msg
end

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
