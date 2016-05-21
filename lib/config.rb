# Base class for property types
class Property
  attr_reader :name, :value

  private

  attr_writer :value

  public

  def initialize(name, value)
    @name = name
    @value = value
  end

  def to_s
    validate
    super
  end

  def validate
    self.value ||= ''
    raise 'Property name should be String' unless name.is_a? String
    raise "Property name can't be empty" if name.empty?
    raise "Property value can't be empty" if value.empty?
  end
end

# Represents String property type, extends Property class
class StringProperty < Property
  def iniitialize(name, value)
    super name, value
  end

  def validate
    super
    raise 'Property value should be String' unless value.is_a? String
  end

  def to_s
    validate
    "--#{name} #{value}"
  end
end

# Represents Boolean property type, extends Property class
class BoolProperty < Property
  def iniitialize(name, value)
    super name, value
  end

  def to_s
    if name
      "--#{name} #{value}"
    else
      ''
    end
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
