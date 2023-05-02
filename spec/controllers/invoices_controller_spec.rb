require 'rails_helper'

RSpec.describe InvoicesController, type: :controller do
  describe 'InvoicesController' do
    let(:invoice) { FactoryBot.create :invoice }

    describe '#show' do
      it 'should return the invoice with given id' do
        get :show, params: { id: invoice.id }
        expect(response).to be_successful
        expect(assigns(:invoice)).to eql(invoice)
      end
    end
  end
end
