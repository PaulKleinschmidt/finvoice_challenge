class AddFeePercentageToInvoices < ActiveRecord::Migration[7.0]
  def change
    add_column :invoices, :fee_percentage, :decimal
  end
end
