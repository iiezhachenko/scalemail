require_relative '../../lib/scalemail'

describe Scalemail::Attributes do
  it '#factory returns array of Attribute objects from provided hash' do
    hash = { 'driver' => 'value' }
    attributes = Scalemail::Attributes.factory hash
    expect(attributes.is_a?(Array)).to eq true
    attributes.each do |attr|
      expect(attr.respond_to?(:string)).to eq true
    end
  end
  it '#factory returns Attribute object according to attributes catalogue' do
    hash = {
      'driver' => 'amazonec2',
      'engine-opt' => [1, 2],
      'swarm-experimental' => true
    }
    attributes = Scalemail::Attributes.factory hash
    expect(attributes[0].is_a?(Scalemail::StringAttribute)).to eq true
    expect(attributes[1].is_a?(Scalemail::ArrayAttribute)).to eq true
    expect(attributes[2].is_a?(Scalemail::BooleanAttribute)).to eq true
  end
end
