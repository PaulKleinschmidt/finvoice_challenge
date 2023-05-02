class Invoice < ApplicationRecord
  before_update :check_status_transition

  belongs_to :client
  enum :status, { created: 0, approved: 1, purchased: 2, closed: 3, rejected: 4 }

  def check_status_transition
    return unless status_changed?

    old_status, new_status = status_change

    return if valid_status_transition?(old_status, new_status)

    errors.add(:status, "can't transition from #{old_status} to #{new_status}")
    throw :abort
  end

  private

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
