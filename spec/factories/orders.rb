FactoryBot.define do
  factory :order do
    user { nil }
    status { 1 }
    user_address_id {1}
  end
end
