require_relative 'attribute.rb'

# Represents Array attribute type, extends Attribute class
class ArrayAttribute < Attribute
  def to_s
    validate
    str = []
    value.each do |item|
      str.push "--#{name}=#{item}"
    end
    str.join ' '
  end

  private

  def additional_validations
    raise "Attribute value can't be empty" if value.empty?
    raise 'Attribute value should be Array' unless value.is_a? Array
  end
end
