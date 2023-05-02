require 'rails_helper'

RSpec.describe InvoicesController, type: :controller do
  describe '#show' do
    let(:invoice) { FactoryBot.create :invoice }

    it 'should return the invoice with given id' do
      get :show, params: { id: invoice.id }
      expect(response).to be_successful
      expect(assigns(:invoice)).to eql(invoice)
    end
  end

  describe '#create' do
    let(:client) { FactoryBot.create :client }

    let(:new_invoice_params) do
      {
        invoice_id: 'INV001',
        amount: 1000,
        due_date: Date.today + 30.days,
        invoice_scan: 'abc123',
        client_id: client.id
      }
    end

    it 'should create an invoice with the created status' do
      post :create, params: { invoice: new_invoice_params }
      expect(response).to be_successful
      expect(assigns(:invoice)).to be_persisted
      expect(assigns(:invoice).status).to eq('created')
    end
  end

  describe '#update' do
    let(:invoice) { FactoryBot.create :invoice }
    let(:approved_invoice) { FactoryBot.create(:invoice, status: :approved, amount: 10) }
    let(:purchased_invoice) { FactoryBot.create(:invoice, status: :purchased, amount: 10) }
    let!(:fee) { FactoryBot.create(:fee, invoice: purchased_invoice) }

    it 'should update the status if status change is valid' do
      put :update, params: { id: invoice.id, invoice: { status: :rejected } }
      expect(response).to be_successful
      expect(assigns(:invoice).status).to eq('rejected')
    end

    it 'should error if the status if status change is invalid' do
      put :update, params: { id: invoice.id, invoice: { status: 'purchased' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("can't transition from created to purchased")
    end

    it 'create a new fee if the status is changed to purchased' do
      put :update, params: { id: approved_invoice.id, invoice: { status: :purchased } }
      expect(response).to be_successful
      expect(Fee.last).to have_attributes(
        invoice_id: approved_invoice.id,
        purchase_date: Date.current,
        end_date: nil,
        amount: 1.0
      )
      expect(assigns(:invoice).status).to eq('purchased')
    end

    it 'updates the fee end_date if the status is changed to closed' do
      put :update, params: { id: purchased_invoice.id, invoice: { status: :closed } }
      expect(response).to be_successful
      expect(Fee.last).to have_attributes(
        invoice_id: purchased_invoice.id,
        end_date: Date.current
      )
      expect(assigns(:invoice).status).to eq('closed')
    end
  end
end
