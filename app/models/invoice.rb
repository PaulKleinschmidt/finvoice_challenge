class Invoice < ApplicationRecord
  validates :invoice_id, :amount, :due_date, :status, :invoice_scan, presence: true
  validates :invoice_id, uniqueness: true

  enum :status, { created: 0, approved: 1, purchased: 2, closed: 3, rejected: 4 }
  has_one :fee
  belongs_to :client

  before_update :check_status_transition
  after_update :create_fee, if: :purchased?
  after_update :update_fee_end_date, if: :closed?

  def check_status_transition
    return unless status_changed?

    old_status, new_status = status_change

    return if valid_status_transition?(old_status, new_status)

    errors.add(:status, "can't transition from #{old_status} to #{new_status}")
    raise ActiveRecord::RecordInvalid
  end

  def create_fee
    Fee.create(invoice: self, amount: amount * fee_percentage, purchase_date: Date.current)
  end

  def update_fee_end_date
    fee.update!(end_date: Date.current)
  end

  private

  def fee_percentage
    0.10
  end

  def valid_status_transition?(old_status, new_status)
    case old_status
    when 'created'
      %w[approved rejected].include? new_status
    when 'approved'
      new_status == 'purchased'
    when 'purchased'
      new_status == 'closed'
    else
      false
    end
  end
end
