FactoryGirl.define do
  factory :property, class: Property do
    name 'name'
    value 'value'

    initialize_with { new name, value }
  end

  factory :string_property, class: StringProperty do
    name 'name'
    value 'value'

    initialize_with { new name, value }
  end

  factory :bool_property, class: BoolProperty do
    name 'name'
    value false

    initialize_with { new name, value }
  end

  factory :array_property, class: ArrayProperty do
    name 'name'
    value %w(one two)

    initialize_with { new name, value }
  end
end
