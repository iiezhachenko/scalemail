# Base class for Attributes
class Attribute
  attr_reader :name, :value

  def initialize(name, value)
    @name = name
    @value = value
  end

  def to_s
    validate
    raise(NotImplementedError, \
          'This is a generic class. Use specialized child instead')
  end

  private

  attr_writer :value

  def validate
    raise 'Attribute name should be String' unless name.is_a? String
    raise "Attribute name can't be empty" if name.empty?
    additional_validations
  end

  def additional_validations
    nil
  end
end
