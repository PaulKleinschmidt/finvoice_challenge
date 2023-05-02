FactoryBot.define do
  factory :fee do
    invoice { nil }
    amount { 1.5 }
    start_date { "2023-05-01" }
    end_date { "2023-05-01" }
  end
end
