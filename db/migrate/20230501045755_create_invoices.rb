class CreateInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table :invoices do |t|
      t.string :invoice_id
      t.decimal :amount
      t.date :due_date
      t.integer :status, default: 0
      t.binary :invoice_scan
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
