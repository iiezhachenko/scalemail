def raise_test(test_obj, err, exception = RuntimeError)
  it "throws #{exception}" do
    expect { fixture.to_s }.to \
      raise_error(exception, "Attribute #{test_obj} #{err}")
  end
end

def test_to_s(expected_msg)
  it 'should return string for usage with Docker Machine' do
    expect(fixture.to_s).to be == expected_msg
  end
end

shared_examples_for 'Attribute' do |factory|
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
