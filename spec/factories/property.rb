FactoryGirl.define do
  factory :property do
    name 'name'
    value 'value'

    initialize_with { new name, value }
  end

  factory :string_property, class: StringProperty do
    name 'name'
    value 'value'

    initialize_with { new name, value }
  end
end
