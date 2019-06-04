FactoryBot.define do
  factory :user do
    password_digest { "password" }
    role { 0 }
    active { true }

    sequence :name do |n|
      "User #{n}"
    end

    # address { "1234 Test Rd." }
    # city { "Denver" }
    # state { "CO" }
    # zip { "80123" }

    sequence :email do |n|
      "person#{n}@example.com"
    end
  end
end
