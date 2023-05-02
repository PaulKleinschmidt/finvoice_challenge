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
  end
end
