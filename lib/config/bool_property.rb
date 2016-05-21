require_relative 'property.rb'

# Represents Boolean property type, extends Property class
class BoolProperty < Property
  def iniitialize(name, value)
    super name, value
  end

  def to_s
    validate
    if value
      "--#{name}"
    else
      ''
    end
  end

  private

  def validate
    super
    raise 'Property value should be Boolean' unless [true, false].include? value
  end
end
