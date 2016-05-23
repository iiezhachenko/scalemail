require_relative '../../lib/config/config'
require 'tempfile'

describe Config do
  context 'called #load_yaml_file on given YML file' do
    it 'should set proper options_hash and hosts_hash' do
      content = [
        'options:',
        '  item1: value',
        'hosts:',
        '  host1:',
        '    attr1: val'
      ]
      file = Tempfile.open('tst')
      file.write(content.join("\n"))
      file.close
      Config.instance.load_yaml_file(file)
      expect(Config.instance.options_hash).to eq('item1' => 'value')
      expect(Config.instance.hosts_hash).to eq('host1' => { 'attr1' => 'val' })
    end
  end
end
