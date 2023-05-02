class CreateFees < ActiveRecord::Migration[7.0]
  def change
    create_table :fees do |t|
      t.references :invoice, null: false, foreign_key: true
      t.float :amount
      t.date :purchase_date
      t.date :end_date

      t.timestamps
    end
  end
end
