FactoryBot.define do
  factory :fee do
    amount { Faker::Number.decimal(l_digits: 2) }
    purchase_date { Faker::Time.between(from: 2.days.ago, to: Time.now) }
    end_date { nil }
    association :invoice
  end
end
