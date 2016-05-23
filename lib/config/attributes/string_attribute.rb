require_relative 'attribute.rb'

# Represents String attribute type, extends Attribute class
class StringAttribute < Attribute
  def to_s
    validate
    "--#{name} #{value}"
  end

  private

  def additional_validations
    raise "Attribute value can't be empty" if value.empty?
    raise 'Attribute value should be String' unless value.is_a? String
  end
end
