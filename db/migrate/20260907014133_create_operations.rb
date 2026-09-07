class CreateOperations < ActiveRecord::Migration[8.1]
  def change
    create_table :operations do |t|
      t.references :work_order, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :position, null: false
      t.integer :status, null: false, default: 0
      t.datetime :completed_at

      t.timestamps
    end
  end
end
