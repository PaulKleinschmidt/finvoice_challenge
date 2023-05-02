require 'rails_helper'

RSpec.describe Invoice, type: :model do
  let(:invoice) { FactoryBot.build(:invoice) }
  let(:approved_invoice) { FactoryBot.create(:invoice, status: :approved) }
  let(:purchased_invoice) { FactoryBot.create(:invoice, status: :purchased) }
  let(:closed_invoice) { FactoryBot.create(:invoice, status: :closed) }
  let!(:fee) { FactoryBot.create(:fee, invoice: purchased_invoice) }

  describe 'validations' do
    it { should validate_presence_of(:invoice_id) }
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:invoice_scan) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:due_date) }
  end

  describe 'before_update' do
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

    it 'creates a new fee if the status is changed to purchased' do
      invoice = approved_invoice
      expect do
        invoice.update!(status: :purchased)
      end.to change(Fee, :count).by(1)

      expect(invoice.fee).to have_attributes(
        invoice_id: invoice.id,
        purchase_date: Date.current,
        end_date: nil,
        amount: invoice.amount * 0.10
      )
    end

    it 'updates the fee end date if the status is changed to closed' do
      purchased_invoice.update!(status: :closed)
      expect(fee.reload.end_date).to eq(Date.current)
    end
  end
end
