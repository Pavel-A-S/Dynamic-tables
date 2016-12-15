class CreateDecimalCells < ActiveRecord::Migration
  def change
    create_table :decimal_cells do |t|
      t.integer :record_id
      t.integer :cell_id
      t.decimal :data, precision: 13, scale: 4

      t.timestamps null: false
    end
  end
end
