require 'singleton'
require 'yaml'

# Class responcible for configuration storage and processing
class Config
  include Singleton
  attr_reader :options_hash, :hosts_hash

  def load_yaml_file(file_path)
    template = ERB.new File.new(file_path).read
    cfg_hash = YAML.load template.result(binding)
    self.options_hash = cfg_hash['options']
    self.hosts_hash = cfg_hash['hosts']
  end

  private

  attr_writer :options_hash, :hosts_hash
end
