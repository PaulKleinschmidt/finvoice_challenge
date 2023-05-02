FactoryBot.define do
  factory :invoice do
    invoice_id { Faker::Alphanumeric.alpha(number: 10) }
    amount { Faker::Number.decimal(l_digits: 2) }
    due_date { Faker::Time.between(from: 2.days.ago, to: Time.now) }
    invoice_scan { Faker::Alphanumeric.alpha(number: 10) }
    association :client
  end
end
