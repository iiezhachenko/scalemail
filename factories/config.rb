FactoryGirl.define do
  factory :primitive_config, class: Scalemail::Config do
    options { { hosts_name_prefix: 'test' } }
    hosts { { host: { options: {}, attributes: {} } } }
  end
end
