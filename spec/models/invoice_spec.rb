require 'rails_helper'

RSpec.describe Invoice, type: :model do
  let(:created_invoice) { FactoryBot.create(:invoice, status: :created) }
  let(:created_invoice2) { FactoryBot.create(:invoice, status: :created) }
  let(:approved_invoice) { FactoryBot.create(:invoice, status: :approved, amount: 10, fee_percentage: 10) }
  let(:purchased_invoice) { FactoryBot.create(:invoice, status: :purchased) }
  let(:closed_invoice) { FactoryBot.create(:invoice, status: :closed) }
  let!(:fee) { FactoryBot.create(:fee, invoice: purchased_invoice) }

  describe 'validations' do
    it { should validate_presence_of(:invoice_id) }
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:invoice_scan) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:due_date) }
    it { should validate_presence_of(:fee_percentage) }
  end

  describe 'before_update' do
    it 'does not allow invalid status transitions' do
      expect do
        created_invoice.update!(status: :closed)
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'allows valid status transitions' do
      invoice = created_invoice
      invoice.update!(status: :approved)
      expect(invoice.reload.status).to eq('approved')

      invoice.update!(status: :purchased)
      expect(invoice.reload.status).to eq('purchased')

      invoice.update!(status: :closed)
      expect(invoice.reload.status).to eq('closed')

      created_invoice2.update!(status: :rejected)
      expect(created_invoice2.reload.status).to eq('rejected')
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
        amount: 1.0
      )
    end

    it 'updates the fee end date if the status is changed to closed' do
      purchased_invoice.update!(status: :closed)
      expect(fee.reload.end_date).to eq(Date.current)
    end
  end
end
