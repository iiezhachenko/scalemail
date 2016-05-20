class Property
  attr_reader :name, :value

  def initialize(name, value)
    @name = name
    @value = value
  end

  def to_s
    validate
    super
  end

  def validate
    raise 'Property name should be String' unless name.is_a? String
    raise "Property name can't be empty" if name.empty?
    raise "Property value can't be nil" if value.nil?
  end
end

class StringProperty < Property
  def iniitialize(name, value)
    super name, value
  end

  def validate
    super
    raise 'Property value should be String' unless value.is_a? String
  end

  def to_s
    "--#{name} #{value}"
  end
end

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
