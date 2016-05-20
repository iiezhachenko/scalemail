require_relative '../lib/config'

def raise_test(test_obj, err, exception = RuntimeError)
  it "throws #{exception}" do
    require'pry';binding.pry
    expect { property.to_s }.to \
      raise_error(exception, "Property #{test_obj} #{err}")
  end
end

shared_examples_for 'a Property' do
  context '#new' do
    let(:name) { 'name' }
    let(:value) { 'value' }
    it 'builds object when given both args' do
      prop = Property.new name, value
      expect(prop.name).to eq name
      expect(prop.value).to eq value
    end
  end
  context "name isn't String" do
    let(:property) { create(:property, name: nil) }
    raise_test 'name', 'should be String'
  end
  # context 'name is empty' do
  #   let(:name) { '' }
  #   let(:value) { 'value' }
  #   raise_test 'name', "can't be empty"
  # end
  # context 'value is nil' do
  #   let(:name) { 'name' }
  #   let(:value) { nil }
  #   raise_test 'value', "can't be nil"
  # end
end

describe Property do
  subject { Property }
  context '#new' do
    it_behaves_like 'a Property'
  end
end

describe StringProperty do
  subject { StringProperty }
  context '#new' do
    it_behaves_like 'a Property'
    context 'value not String' do
      let(:name) { 'name' }
      let(:value) { [1, 2] }
      raise_test 'value', 'should be String'
    end
  end
end
