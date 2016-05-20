require_relative './verifier'

# Class provides useful utility methods
class Utils
  def self.load_yaml(file_path)
    check_file file_path
    template = ERB.new File.new(file_path).read
    YAML.load template.result(binding)
  end

  class << self
    private

    def check_file(file_path)
      Verifier.check_file(file_path)
    end
  end
end
