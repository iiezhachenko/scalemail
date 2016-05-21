require_relative 'property.rb'

# Represents String property type, extends Property class
class StringProperty < Property
  def iniitialize(name, value)
    super name, value
  end

  def to_s
    validate
    "--#{name} #{value}"
  end

  private

  def validate
    super
    raise "Property value can't be empty" if value.empty?
    raise 'Property value should be String' unless value.is_a? String
  end
end
