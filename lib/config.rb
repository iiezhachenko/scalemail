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

# Represents Array property type, extends Property class
class ArrayProperty < Property
  def iniitialize(name, value)
    super name, value
  end

  def to_s
    value.each do |item|
      "--#{name}=#{item}"
    end
  end
end
