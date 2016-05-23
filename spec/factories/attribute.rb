require_relative '../../lib/config/attributes/attribute'
require_relative '../../lib/config/attributes/string_attribute'
require_relative '../../lib/config/attributes/bool_attribute'
require_relative '../../lib/config/attributes/array_attribute'

FactoryGirl.define do
  factory :attribute, class: Attribute do
    name 'name'
    value 'value'

    initialize_with { new name, value }
  end

  factory :string_attribute, class: StringAttribute do
    name 'name'
    value 'value'

    initialize_with { new name, value }
  end

  factory :bool_attribute, class: BoolAttribute do
    name 'name'
    value false

    initialize_with { new name, value }
  end

  factory :array_attribute, class: ArrayAttribute do
    name 'name'
    value %w(one two)

    initialize_with { new name, value }
  end
end
