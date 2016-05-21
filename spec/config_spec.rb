require_relative '../lib/config'

def raise_test(test_obj, err, exception = RuntimeError)
  it "throws #{exception}" do
    expect { fixture.to_s }.to \
      raise_error(exception, "Property #{test_obj} #{err}")
  end
end

shared_examples_for 'Property' do |factory|
  let(:fixture) { build factory }
  context '#new' do
    it 'builds object when given both args' do
      name = fixture.name
      value = fixture.value
      prop = subject.new name, value
      expect(prop.name).to eq name
      expect(prop.value).to eq value
    end
  end
  context '#to_s' do
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

describe Property do
  subject { Property }
  include_examples 'Property', :property
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
  end
end
