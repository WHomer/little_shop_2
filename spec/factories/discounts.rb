FactoryBot.define do
  factory :discount do
    description { "MyString" }
    discount { 1.5 }
    quilfier_quantitiy { 1 }
    quilfier_value { 1 }
    user { nil }
  end
end
