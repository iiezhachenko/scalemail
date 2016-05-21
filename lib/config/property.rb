# Base class for property types
class Property
  attr_reader :name, :value

  def initialize(name, value)
    @name = name
    @value = value
  end

  def to_s
    validate
    'This is a generic class. Use specialized child instead'
  end

  private

  attr_writer :value

  def validate
    raise 'Property name should be String' unless name.is_a? String
    raise "Property name can't be empty" if name.empty?
  end
end
