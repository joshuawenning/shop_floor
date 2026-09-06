class CreateParts < ActiveRecord::Migration[8.1]
  def change
    create_table :parts do |t|
      t.string :number, null: false
      t.string :name, null: false
      t.string :revision
      t.integer :inventory_quantity, null: false, default: 0

      t.timestamps
    end

    add_index :parts, :number, unique: true
  end
end
