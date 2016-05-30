require_relative '../../lib/scalemail'

describe Scalemail::Host do
  before do
    Attribute = Struct.new(:name, :value) do
      def string
        "--#{name} #{value}"
      end
    end
    allow(Scalemail::Attributes).to receive(:factory)
      .and_return([Attribute.new('attr1', 'value')])
  end
  it '#name and #options_hash and #attributes_hash are taken from init args' do
    host_hash = {
      'options' => {
        'opt1' =>  'value'
      },
      'attributes' => {
        'attr1' => 'value'
      }
    }
    host = Scalemail::Host.new 'HostName', host_hash
    expect(host.name).to eq 'HostName'
    expect(host.options_hash).to eq 'opt1' => 'value'
    expect(host.attributes_hash).to eq 'attr1' => 'value'
  end
  it '#creation_string raise error if attributes not specified for host' do
    host_hash = {
      'options' => {
        'opt1' =>  'value'
      }
    }
    expect { Scalemail::Host.new 'HostName', host_hash }.to \
      raise_error 'Attributes not specified for host HostName'
  end
  it '#creation_string returns docker-machine create commmand' do
    host_hash = {
      'options' => {
        'opt1' =>  'value'
      },
      'attributes' => {
        'amazonec2-region' => 'value'
      }
    }
    host = Scalemail::Host.new 'HostName', host_hash
    expect(host.creation_string).to \
      eq 'docker-machine create --attr1 value HostName'
  end
end
