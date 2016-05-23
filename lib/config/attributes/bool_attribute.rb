require_relative 'attribute.rb'

# Represents Boolean attribute type, extends Attribute class
class BoolAttribute < Attribute
  def to_s
    validate
    if value
      "--#{name}"
    else
      ''
    end
  end

  private

  def additional_validations
    raise 'Attribute value should be Boolean' \
      unless [true, false].include? value
  end
end
