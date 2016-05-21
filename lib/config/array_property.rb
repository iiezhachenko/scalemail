require_relative 'property.rb'

# Represents Array property type, extends Property class
class ArrayProperty < Property
  def iniitialize(name, value)
    super name, value
  end

  def to_s
    validate
    str = []
    value.each do |item|
      str.push "--#{name}=#{item}"
    end
    str.join ' '
  end

  private

  def validate
    super
    raise "Property value can't be empty" if value.empty?
    raise 'Property value should be Array' unless value.is_a? Array
  end
end
