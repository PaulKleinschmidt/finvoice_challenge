require 'rails_helper'

RSpec.describe Invoice, type: :model do
  let(:invoice) { FactoryBot.build(:invoice) }

  describe 'validations' do
    it { should validate_presence_of(:invoice_id) }
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:invoice_scan) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:due_date) }
  end

  describe 'status transitions' do
    it 'does not allow invalid status transitions' do
      invoice.status = :created
      invoice.save

      expect do
        invoice.update!(status: :closed)
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'allows valid status transitions' do
      invoice.status = :created
      invoice.save

      expect do
        invoice.update(status: :approved)
      end.to_not raise_error
    end
  end
end
