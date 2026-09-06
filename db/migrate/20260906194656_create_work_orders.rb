class CreateWorkOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :work_orders do |t|
      t.string :number, null: false
      t.references :part, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.date :due_on, null: false
      t.integer :status, null: false, default: 0
      t.text :notes

      t.timestamps
    end

    add_index :work_orders, :number, unique: true
  end
end
