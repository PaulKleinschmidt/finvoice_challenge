class Client < ApplicationRecord
  has_many :invoices, dependent: :destroy
end
